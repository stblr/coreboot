/* SPDX-License-Identifier: GPL-2.0-only */

#include <stdint.h>
#include <arch/romstage.h>
#include <cpu/intel/haswell/haswell.h>
#include <device/pnp_ops.h>
#include <northbridge/intel/haswell/haswell.h>
#include <northbridge/intel/haswell/pei_data.h>
#include <southbridge/intel/common/gpio.h>
#include <southbridge/intel/lynxpoint/pch.h>

static const struct rcba_config_instruction rcba_config[] = {
	RCBA_SET_REG_16(D31IR, DIR_ROUTE(PIRQA, PIRQD, PIRQC, PIRQA)),
	RCBA_SET_REG_16(D29IR, DIR_ROUTE(PIRQH, PIRQD, PIRQA, PIRQC)),
	RCBA_SET_REG_16(D28IR, DIR_ROUTE(PIRQA, PIRQA, PIRQA, PIRQA)),
	RCBA_SET_REG_16(D27IR, DIR_ROUTE(PIRQG, PIRQB, PIRQC, PIRQD)),
	RCBA_SET_REG_16(D26IR, DIR_ROUTE(PIRQA, PIRQF, PIRQC, PIRQD)),
	RCBA_SET_REG_16(D25IR, DIR_ROUTE(PIRQE, PIRQF, PIRQG, PIRQH)),
	RCBA_SET_REG_16(D22IR, DIR_ROUTE(PIRQA, PIRQD, PIRQC, PIRQB)),
	RCBA_SET_REG_16(D20IR, DIR_ROUTE(PIRQA, PIRQB, PIRQC, PIRQD)),

	RCBA_RMW_REG_32(FD, ~0, PCH_DISABLE_ALWAYS),

	RCBA_END_CONFIG,
};

void mainboard_romstage_entry(void)
{
	struct pei_data pei_data = {
		.pei_version = PEI_VERSION,
		.mchbar = (uintptr_t)DEFAULT_MCHBAR,
		.dmibar = (uintptr_t)DEFAULT_DMIBAR,
		.epbar = DEFAULT_EPBAR,
		.pciexbar = CONFIG_MMCONF_BASE_ADDRESS,
		.smbusbar = SMBUS_IO_BASE,
		.hpet_address = HPET_ADDR,
		.rcba = (uintptr_t)DEFAULT_RCBA,
		.pmbase = DEFAULT_PMBASE,
		.gpiobase = DEFAULT_GPIOBASE,
		.temp_mmio_base = 0xfed08000,
		.system_type = 1, /* desktop/server */
		.tseg_size = CONFIG_SMM_TSEG_SIZE,
		.spd_addresses = { 0xa0, 0xa2, 0xa4, 0xa6 },
		.ec_present = 0,
		.gbe_enable = 1,
		.dimm_channel0_disabled = 0,
		.dimm_channel1_disabled = 0,
		.max_ddr3_freq = 1600,
		.usb2_ports = {
			/* Length, Enable, OCn#, Location */
			{ 0x0040, 1, 0, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 0, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 1, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, USB_OC_PIN_SKIP, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, USB_OC_PIN_SKIP, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 2, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 3, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 3, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 4, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 4, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 5, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 5, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 6, USB_PORT_BACK_PANEL },
			{ 0x0040, 1, 6, USB_PORT_BACK_PANEL },
		},
		.usb3_ports = {
			{ 1, 0 },
			{ 1, 0 },
			{ 1, 1 },
			{ 1, 1 },
			{ 1, 2 },
			{ 1, 2 },
		},
	};

	struct romstage_params romstage_params = {
		.pei_data = &pei_data,
		.gpio_map = &mainboard_gpio_map,
		.rcba_config = &rcba_config[0],
	};

	romstage_common(&romstage_params);
}
