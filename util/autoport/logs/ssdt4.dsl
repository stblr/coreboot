/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200430 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt4.dat, Sat Jun 13 11:38:38 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000283 (643)
 *     Revision         0x01
 *     Checksum         0x07
 *     OEM ID           "HPQOEM"
 *     OEM Table ID     "SataAhci"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20060912 (537266450)
 */
DefinitionBlock ("", "SSDT", 1, "HPQOEM", "SataAhci", 0x00001000)
{
    External (_SB_.PCI0.SATA, DeviceObj)
    External (GIV_, UnknownObj)
    External (GPIE, UnknownObj)
    External (GPIS, UnknownObj)
    External (GPL0, UnknownObj)
    External (GPL3, UnknownObj)
    External (GPSL, UnknownObj)

    Scope (\_SB.PCI0.SATA)
    {
        Device (PRT0)
        {
            Name (_ADR, 0xFFFF)  // _ADR: Address
            Name (GTH0, Buffer (0x07)
            {
                 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
            })
            Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
            {
                GTH0 = Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    }
                Return (GTH0) /* \_SB_.PCI0.SATA.PRT0.GTH0 */
            }
        }

        Device (PRT1)
        {
            Name (_ADR, 0x0001FFFF)  // _ADR: Address
            Name (GTH1, Buffer (0x07)
            {
                 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
            })
            Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
            {
                GTH1 = Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    }
                Return (GTH1) /* \_SB_.PCI0.SATA.PRT1.GTH1 */
            }

            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                Return (HDSM (Arg0, Arg1, Arg2, Arg3))
            }
        }

        Device (PRT2)
        {
            Name (_ADR, 0x0002FFFF)  // _ADR: Address
            Name (GTH2, Buffer (0x07)
            {
                 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
            })
            Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
            {
                GTH2 = Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    }
                Return (GTH2) /* \_SB_.PCI0.SATA.PRT2.GTH2 */
            }
        }

        Device (PRT3)
        {
            Name (_ADR, 0x0003FFFF)  // _ADR: Address
            Name (GTF3, Buffer (0x07)
            {
                 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
            })
            Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
            {
                GTF3 = Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    }
                Return (GTF3) /* \_SB_.PCI0.SATA.PRT3.GTF3 */
            }
        }

        Device (PRT5)
        {
            Name (_ADR, 0x0005FFFF)  // _ADR: Address
            Name (GTF5, Buffer (0x07)
            {
                 0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
            })
            Method (_GTF, 0, NotSerialized)  // _GTF: Get Task File
            {
                GTF5 = Buffer (0x07)
                    {
                         0x00, 0x00, 0x00, 0x00, 0x00, 0xA0, 0x00         // .......
                    }
                Return (GTF5) /* \_SB_.PCI0.SATA.PRT5.GTF5 */
            }
        }
    }

    Method (HDSM, 4, Serialized)
    {
        If ((Arg0 == ToUUID ("bdfaef30-aebb-11de-8a39-0800200c9a66")))
        {
            If ((ToInteger (Arg2) == 0x00))
            {
                If ((ToInteger (Arg1) == 0x01))
                {
                    Return (Buffer (0x01)
                    {
                         0x0F                                             // .
                    })
                }
                Else
                {
                    Return (Buffer (0x01)
                    {
                         0x00                                             // .
                    })
                }
            }
            ElseIf ((ToInteger (Arg2) == 0x01))
            {
                Return (0x01)
            }
            ElseIf ((ToInteger (Arg2) == 0x02))
            {
                Local0 = (GPSL & ~0x08)
                GPSL = Local0
                Local1 = (GPL0 & 0x08)
                If ((Local1 == 0x08))
                {
                    GIV |= 0x08
                }
                Else
                {
                    GIV &= ~0x08
                }

                Local0 = (GPL3 & ~0x10)
                GPL3 = Local0
                Sleep (0xC8)
                Local1 = (GPIE & 0x08)
                If ((Local1 != 0x08))
                {
                    Local0 = (GPIE | 0x08)
                    GPIE = Local0
                }

                GPSL |= 0x08
                Return (0x01)
            }
            ElseIf ((ToInteger (Arg2) == 0x03))
            {
                GPIE &= ~0x08
                GPIS |= 0x08
                Local0 = (GPL3 | 0x10)
                GPL3 = Local0
                Return (0x01)
            }
            Else
            {
                Return (0x00)
            }
        }
        Else
        {
            Return (0x00)
        }
    }
}

