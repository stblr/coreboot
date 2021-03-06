/* SPDX-License-Identifier: GPL-2.0-only */

#include <device/mmio.h>
#include <device/device.h>
#include <console/console.h>
#include <gpio.h>
#include <amdblocks/acpimmio.h>
#include <amdblocks/acpimmio_map.h>
#include <soc/gpio.h>
#include <soc/smi.h>
#include <assert.h>

static int get_gpio_gevent(uint8_t gpio, const struct soc_amd_event *table,
				size_t items)
{
	int i;

	for (i = 0; i < items; i++) {
		if ((table + i)->gpio == gpio)
			return (int)(table + i)->event;
	}
	return -1;
}

static void mem_read_write32(uint32_t *address, uint32_t value, uint32_t mask)
{
	uint32_t reg32;

	value &= mask;
	reg32 = read32(address);
	reg32 &= ~mask;
	reg32 |= value;
	write32(address, reg32);
}

static void program_smi(uint32_t flag, int gevent_num)
{
	uint32_t trigger;

	trigger = flag & FLAGS_TRIGGER_MASK;
	/*
	 * Only level trigger is allowed for SMI. Trigger values are 0
	 * through 3, with 0-1 being level trigger and 2-3 being edge
	 * trigger. GPIO_TRIGGER_EDGE_LOW is 2, so trigger has to be
	 * less than GPIO_TRIGGER_EDGE_LOW.
	 */
	assert(trigger < GPIO_TRIGGER_EDGE_LOW);

	if (trigger == GPIO_TRIGGER_LEVEL_HIGH)
		configure_gevent_smi(gevent_num, SMI_MODE_SMI,
					SMI_SCI_LVL_HIGH);
	if (trigger == GPIO_TRIGGER_LEVEL_LOW)
		configure_gevent_smi(gevent_num, SMI_MODE_SMI,
					SMI_SCI_LVL_LOW);
}

static void get_sci_config_bits(uint32_t flag, uint32_t *edge, uint32_t *level)
{
	uint32_t trigger;

	trigger = flag & FLAGS_TRIGGER_MASK;
	switch (trigger) {
	case GPIO_TRIGGER_LEVEL_LOW:
		*edge = SCI_TRIGGER_LEVEL;
		*level = 0;
		break;
	case GPIO_TRIGGER_LEVEL_HIGH:
		*edge = SCI_TRIGGER_LEVEL;
		*level = 1;
		break;
	case GPIO_TRIGGER_EDGE_LOW:
		*edge = SCI_TRIGGER_EDGE;
		*level = 0;
		break;
	case GPIO_TRIGGER_EDGE_HIGH:
		*edge = SCI_TRIGGER_EDGE;
		*level = 1;
		break;
	default:
		break;
	}
}

uintptr_t gpio_get_address(gpio_t gpio_num)
{
	uintptr_t gpio_address;

	if (gpio_num < 64)
		gpio_address = GPIO_BANK0_CONTROL(gpio_num);
	else if (gpio_num < 128)
		gpio_address = GPIO_BANK1_CONTROL(gpio_num);
	else
		gpio_address = GPIO_BANK2_CONTROL(gpio_num);

	return gpio_address;
}

int gpio_get(gpio_t gpio_num)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);

	return !!(reg & GPIO_PIN_STS);
}

void gpio_set(gpio_t gpio_num, int value)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);
	reg &= ~GPIO_OUTPUT_MASK;
	reg |=  !!value << GPIO_OUTPUT_SHIFT;
	write32((void *)gpio_address, reg);
}

void gpio_input_pulldown(gpio_t gpio_num)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);
	reg &= ~GPIO_PULLUP_ENABLE;
	reg |=  GPIO_PULLDOWN_ENABLE;
	write32((void *)gpio_address, reg);
}

void gpio_input_pullup(gpio_t gpio_num)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);
	reg &= ~GPIO_PULLDOWN_ENABLE;
	reg |=  GPIO_PULLUP_ENABLE;
	write32((void *)gpio_address, reg);
}

void gpio_input(gpio_t gpio_num)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);
	reg &= ~GPIO_OUTPUT_ENABLE;
	write32((void *)gpio_address, reg);
}

void gpio_output(gpio_t gpio_num, int value)
{
	uint32_t reg;
	uintptr_t gpio_address = gpio_get_address(gpio_num);

	reg = read32((void *)gpio_address);
	reg |=  GPIO_OUTPUT_ENABLE;
	write32((void *)gpio_address, reg);
	gpio_set(gpio_num, value);
}

const char *gpio_acpi_path(gpio_t gpio)
{
	return "\\_SB.GPIO";
}

uint16_t gpio_acpi_pin(gpio_t gpio)
{
	return gpio;
}

__weak void soc_gpio_hook(uint8_t gpio, uint8_t mux) {}

void program_gpios(const struct soc_amd_gpio *gpio_list_ptr, size_t size)
{
	uint32_t *gpio_ptr, *inter_master;
	uint32_t control, control_flags, edge_level, direction;
	uint32_t mask, bit_edge, bit_level;
	uint8_t mux, index, gpio;
	int gevent_num;
	const struct soc_amd_event *gev_tbl;
	size_t gev_items;

	inter_master = (uint32_t *)(uintptr_t)(ACPIMMIO_GPIO0_BASE
					       + GPIO_MASTER_SWITCH);
	direction = 0;
	edge_level = 0;
	mask = 0;

	/*
	 * Disable blocking wake/interrupt status generation while updating
	 * debounce registers. Otherwise when a debounce register is updated
	 * the whole GPIO controller will zero out all interrupt enable status
	 * bits while the delay happens. This could cause us to drop the bits
	 * due to the read-modify-write that happens on each register.
	 *
	 * Additionally disable interrupt generation so we don't get any
	 * spurious interrupts while updating the registers.
	 */
	mem_read_write32(inter_master, 0, GPIO_MASK_STS_EN | GPIO_INTERRUPT_EN);

	soc_get_gpio_event_table(&gev_tbl, &gev_items);

	for (index = 0; index < size; index++) {
		gpio = gpio_list_ptr[index].gpio;
		mux = gpio_list_ptr[index].function;
		control = gpio_list_ptr[index].control;
		control_flags = gpio_list_ptr[index].flags;

		iomux_write8(gpio, mux & AMD_GPIO_MUX_MASK);
		iomux_read8(gpio); /* Flush posted write */

		soc_gpio_hook(gpio, mux);

		gpio_ptr = (uint32_t *)gpio_get_address(gpio);

		if (control_flags & GPIO_SPECIAL_FLAG) {
			gevent_num = get_gpio_gevent(gpio, gev_tbl, gev_items);
			if (gevent_num < 0) {
				printk(BIOS_WARNING, "Warning: GPIO pin %d has"
					" no associated gevent!\n", gpio);
				continue;
			}
			switch (control_flags & GPIO_SPECIAL_MASK) {
			case GPIO_DEBOUNCE_FLAG:
				mem_read_write32(gpio_ptr, control,
						GPIO_DEBOUNCE_MASK);
				break;
			case GPIO_WAKE_FLAG:
				mem_read_write32(gpio_ptr, control,
						INT_WAKE_MASK);
				break;
			case GPIO_INT_FLAG:
				mem_read_write32(gpio_ptr, control,
						AMD_GPIO_CONTROL_MASK);
				break;
			case GPIO_SMI_FLAG:
				mem_read_write32(gpio_ptr, control,
						INT_SCI_SMI_MASK);
				program_smi(control_flags, gevent_num);
				break;
			case GPIO_SCI_FLAG:
				mem_read_write32(gpio_ptr, control,
						INT_SCI_SMI_MASK);
				get_sci_config_bits(control_flags, &bit_edge,
							&bit_level);
				edge_level |= bit_edge << gevent_num;
				direction |= bit_level << gevent_num;
				mask |= (1 << gevent_num);
				soc_route_sci(gevent_num);
				break;
			default:
				printk(BIOS_WARNING, "Error, flags 0x%08x\n",
							control_flags);
				break;
			}
		} else {
			mem_read_write32(gpio_ptr, control,
						AMD_GPIO_CONTROL_MASK);
		}
	}

	/*
	 * Re-enable interrupt status generation.
	 *
	 * We leave MASK_STATUS disabled because the kernel may reconfigure the
	 * debounce registers while the drivers load. This will cause interrupts
	 * to be missed during boot.
	 */
	mem_read_write32(inter_master, GPIO_INTERRUPT_EN, GPIO_INTERRUPT_EN);

	/* Set all SCI trigger direction (high/low) */
	mem_read_write32((uint32_t *)
			(uintptr_t)(ACPIMMIO_SMI_BASE + SMI_SCI_TRIG),
					direction, mask);

	/* Set all SCI trigger level (edge/level) */
	mem_read_write32((uint32_t *)
			(uintptr_t)(ACPIMMIO_SMI_BASE + SMI_SCI_LEVEL),
					edge_level, mask);
}

int gpio_interrupt_status(gpio_t gpio)
{
	uintptr_t gpio_address = gpio_get_address(gpio);
	uint32_t reg = read32((void *)gpio_address);

	if (reg & GPIO_INT_STATUS) {
		/* Clear interrupt status, preserve wake status */
		reg &= ~GPIO_WAKE_STATUS;
		write32((void *)gpio_address, reg);
		return 1;
	}

	return 0;
}

/*
 * This function checks to see if there is an override config present for the
 * provided pad_config. If no override config is present, then the input config
 * is returned. Else, it returns the override config.
 */
static const struct soc_amd_gpio *gpio_get_config(const struct soc_amd_gpio *c,
				const struct soc_amd_gpio *override_cfg_table,
				size_t num)
{
	size_t i;
	if (override_cfg_table == NULL)
		return c;
	for (i = 0; i < num; i++) {
		if (c->gpio == override_cfg_table[i].gpio)
			return override_cfg_table + i;
	}
	return c;
}
void gpio_configure_pads_with_override(const struct soc_amd_gpio *base_cfg,
					size_t base_num_pads,
					const struct soc_amd_gpio *override_cfg,
					size_t override_num_pads)
{
	size_t i;
	const struct soc_amd_gpio *c;

	for (i = 0; i < base_num_pads; i++) {
		c = gpio_get_config(base_cfg + i, override_cfg,
				override_num_pads);
		program_gpios(c, 1);
	}
}
