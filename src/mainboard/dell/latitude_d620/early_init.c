/* SPDX-License-Identifier: GPL-2.0-or-later */

#include <bootblock_common.h>
#include <northbridge/intel/i945/i945.h>
#include <superio/smsc/smscsuperio/smscsuperio.h>

#define SERIAL_DEV PNP_DEV(0x2e, SMSCSUPERIO_SP1)

void bootblock_mainboard_early_init(void)
{
        smscsuperio_enable_serial(SERIAL_DEV, CONFIG_TTYS0_BASE);
}

void mainboard_late_rcba_config(void)
{
	// TODO fix comments

	/* SATA / SMBus interrupt pins */
	RCBA32(D31IP) = 0x00042210; /* default */
	//RCBA32(D30IP) = 0x00002100; /* default */
	/* USB interrupt pins */
	RCBA32(D29IP) = 0x10004321; /* default */
	/* PCIe interrupt pins */
	RCBA32(D28IP) = 0x00214321; /* default */
	/* Audio interrupt pin */
	RCBA32(D27IP) = 0x00000001; /* default */

	RCBA16(D31IR) = 0x3210; /* default */
	//RCBA16(D30IR) = 0x3210; /* default */
	RCBA16(D29IR) = 0x7654;
	RCBA16(D28IR) = 0x3210; /* default */
	RCBA16(D27IR) = 0x3215;

	RCBA32(FD) |= FD_INTLAN;

	RCBA64(IOTR0) = 0x000200010000fe01ULL;
	RCBA64(IOTR3) = 0x000200f0000c0801ULL;
}
