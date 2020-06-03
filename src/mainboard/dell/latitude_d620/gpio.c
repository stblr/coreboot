/* SPDX-License-Identifier: GPL-2.0-or-later */

#include <southbridge/intel/common/gpio.h>

static const struct pch_gpio_set1 pch_gpio_set1_mode = {
	.gpio6 = GPIO_MODE_GPIO, /* SIO_EXT_WAKE# */
	.gpio7 = GPIO_MODE_GPIO, /* LAMP_STATE# */
	.gpio8 = GPIO_MODE_GPIO, /* SIO_EXT_SMI# */
	.gpio9 = GPIO_MODE_GPIO, /* SIO_EXT_SCI# */
	.gpio10 = GPIO_MODE_GPIO,
	.gpio12 = GPIO_MODE_GPIO, /* USB_IDE# */
	.gpio13 = GPIO_MODE_GPIO, /* SATA_DET# */
	.gpio14 = GPIO_MODE_GPIO,
	.gpio15 = GPIO_MODE_GPIO,
	.gpio24 = GPIO_MODE_GPIO,
	.gpio25 = GPIO_MODE_GPIO,
	.gpio26 = GPIO_MODE_GPIO, /* LCD_TST */
	.gpio27 = GPIO_MODE_GPIO,
	.gpio28 = GPIO_MODE_GPIO, /* IDE_RST_MOD */
};

static const struct pch_gpio_set1 pch_gpio_set1_direction = {
	.gpio6 = GPIO_DIR_INPUT,
	.gpio7 = GPIO_DIR_INPUT,
	.gpio8 = GPIO_DIR_INPUT,
	.gpio9 = GPIO_DIR_INPUT,
	.gpio10 = GPIO_DIR_INPUT,
	.gpio12 = GPIO_DIR_INPUT, /* page 23 of the schematics has it wrong */
	.gpio13 = GPIO_DIR_INPUT,
	.gpio14 = GPIO_DIR_OUTPUT,
	.gpio15 = GPIO_DIR_OUTPUT,
	.gpio24 = GPIO_DIR_OUTPUT,
	.gpio25 = GPIO_DIR_OUTPUT,
	.gpio26 = GPIO_DIR_OUTPUT,
	.gpio27 = GPIO_DIR_OUTPUT,
	.gpio28 = GPIO_DIR_OUTPUT,
};

static const struct pch_gpio_set1 pch_gpio_set1_level = {
	.gpio14 = GPIO_LEVEL_LOW,
	.gpio15 = GPIO_LEVEL_LOW,
	.gpio24 = GPIO_LEVEL_LOW,
	.gpio25 = GPIO_LEVEL_LOW,
	.gpio26 = GPIO_LEVEL_LOW,
	.gpio27 = GPIO_LEVEL_HIGH,
	.gpio28 = GPIO_LEVEL_HIGH,
};

static const struct pch_gpio_set1 pch_gpio_set1_invert = {
	.gpio6 = GPIO_INVERT,
	.gpio8 = GPIO_INVERT,
	.gpio9 = GPIO_INVERT,
};

static const struct pch_gpio_set1 pch_gpio_set1_blink = {
};

static const struct pch_gpio_set2 pch_gpio_set2_mode = {
	.gpio33 = GPIO_MODE_GPIO, /* BT_RADIO_DIS */
	.gpio34 = GPIO_MODE_GPIO,
	.gpio38 = GPIO_MODE_GPIO, /* PLTRST_DELAY# */
	.gpio39 = GPIO_MODE_GPIO, /* WWAN_RADIO_DIS# */
};

static const struct pch_gpio_set2 pch_gpio_set2_direction = {
	.gpio33 = GPIO_DIR_OUTPUT,
	.gpio34 = GPIO_DIR_INPUT,
	.gpio38 = GPIO_DIR_OUTPUT,
	.gpio39 = GPIO_DIR_OUTPUT,
};

static const struct pch_gpio_set2 pch_gpio_set2_level = {
	.gpio33 = GPIO_LEVEL_HIGH,
	.gpio38 = GPIO_LEVEL_HIGH,
	.gpio39 = GPIO_LEVEL_HIGH,
};

const struct pch_gpio_map mainboard_gpio_map = {
        .set1 = {
                .mode           = &pch_gpio_set1_mode,
                .direction      = &pch_gpio_set1_direction,
                .level          = &pch_gpio_set1_level,
                .blink          = &pch_gpio_set1_blink,
                .invert         = &pch_gpio_set1_invert,
        },
        .set2 = {
                .mode           = &pch_gpio_set2_mode,
                .direction      = &pch_gpio_set2_direction,
                .level          = &pch_gpio_set2_level,
        },
};
