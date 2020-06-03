/* SPDX-License-Identifier: GPL-2.0-or-later */

#include <device/azalia_device.h>

const u32 cim_verb_data[] = {
	0x83847690,	/* Codec Vendor / Device ID: SigmaTel STAC9200 */
	0x102801c2,	/* Subsystem ID */
	9,		/* Number of 4 dword sets */
	AZALIA_SUBVENDOR(0, 0x102801c2),
	AZALIA_PIN_CFG(0, 0x08, 0x40f000f0),
	AZALIA_PIN_CFG(0, 0x09, 0x40f000f1),
	AZALIA_PIN_CFG(0, 0x0d, 0x0321101f),
	AZALIA_PIN_CFG(0, 0x0e, 0x90170110),
	AZALIA_PIN_CFG(0, 0x0f, 0x90a70120),
	AZALIA_PIN_CFG(0, 0x10, 0x0381102e),
	AZALIA_PIN_CFG(0, 0x11, 0x40f000f2),
	AZALIA_PIN_CFG(0, 0x12, 0x40f000f3),
};

const u32 pc_beep_verbs[0] = {};

AZALIA_ARRAY_SIZES;
