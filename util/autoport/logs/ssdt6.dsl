/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200430 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt6.dat, Sat Jun 13 11:38:38 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000069C (1692)
 *     Revision         0x01
 *     Checksum         0xD2
 *     OEM ID           "PmRef"
 *     OEM Table ID     "Cpu0Cst"
 *     OEM Revision     0x00003001 (12289)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20060912 (537266450)
 */
DefinitionBlock ("", "SSDT", 1, "PmRef", "Cpu0Cst", 0x00003001)
{
    External (_PR_.CPU0, DeviceObj)
    External (CFGD, UnknownObj)
    External (FMBL, UnknownObj)
    External (PDC0, UnknownObj)
    External (PFLV, UnknownObj)
    External (PWRS, UnknownObj)

    Scope (\_PR.CPU0)
    {
        Name (C1LM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x01,               // Bit Width
                    0x02,               // Bit Offset
                    0x0000000000000000, // Address
                    0x01,               // Access Size
                    )
            }, 

            0x01, 
            0x01, 
            0x03E8
        })
        Name (C1LH, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x00,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000000, // Address
                    ,)
            }, 

            0x01, 
            0x01, 
            0x03E8
        })
        Name (C3LM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x01,               // Bit Width
                    0x02,               // Bit Offset
                    0x0000000000000010, // Address
                    0x01,               // Access Size
                    )
            }, 

            0x02, 
            0x9C, 
            0x01F4
        })
        Name (C7SM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x01,               // Bit Width
                    0x02,               // Bit Offset
                    0x0000000000000031, // Address
                    0x01,               // Access Size
                    )
            }, 

            0x03, 
            0xC7, 
            0xC8
        })
        Name (C7LM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x01,               // Bit Width
                    0x02,               // Bit Offset
                    0x0000000000000030, // Address
                    0x01,               // Access Size
                    )
            }, 

            0x03, 
            0xC7, 
            0xC8
        })
        Name (C6LM, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (FFixedHW, 
                    0x01,               // Bit Width
                    0x02,               // Bit Offset
                    0x0000000000000020, // Address
                    0x01,               // Access Size
                    )
            }, 

            0x03, 
            0xB5, 
            0x015E
        })
        Name (C3LI, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000414, // Address
                    ,)
            }, 

            0x02, 
            0x9C, 
            0x01F4
        })
        Name (C6LI, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000415, // Address
                    ,)
            }, 

            0x03, 
            0xB5, 
            0x015E
        })
        Name (C7LI, Package (0x04)
        {
            ResourceTemplate ()
            {
                Register (SystemIO, 
                    0x08,               // Bit Width
                    0x00,               // Bit Offset
                    0x0000000000000416, // Address
                    ,)
            }, 

            0x03, 
            0xC7, 
            0xC8
        })
        Name (C3ST, Package (0x04)
        {
            0x03, 
            Package (0x00){}, 
            Package (0x00){}, 
            Package (0x00){}
        })
        Name (C2ST, Package (0x03)
        {
            0x02, 
            Package (0x00){}, 
            Package (0x00){}
        })
        Name (C1ST, Package (0x02)
        {
            0x01, 
            Package (0x00){}
        })
        Name (CSTF, 0x00)
        Method (_CST, 0, Serialized)  // _CST: C-States
        {
            If ((!CSTF && (CFGD & 0x00400000)))
            {
                C3LI [0x02] = 0x50
                C3LM [0x02] = 0x50
                C7SM [0x02] = 0x6D
                C7LM [0x02] = 0x6D
                C6LM [0x02] = 0x68
                C7LI [0x02] = 0x6D
                C6LI [0x02] = 0x68
                CSTF = Ones
            }

            If (((CFGD & 0x1000) && (PDC0 & 0x0200)))
            {
                If ((!PWRS || (PFLV != FMBL)))
                {
                    If ((CFGD & 0x00010000))
                    {
                        If ((CFGD & 0x08))
                        {
                            C3ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C3ST [0x02] = C3LM /* \_PR_.CPU0.C3LM */
                            C3ST [0x03] = C7SM /* \_PR_.CPU0.C7SM */
                            Return (C3ST) /* \_PR_.CPU0.C3ST */
                        }
                        Else
                        {
                            C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C2ST [0x02] = C7SM /* \_PR_.CPU0.C7SM */
                            Return (C2ST) /* \_PR_.CPU0.C2ST */
                        }
                    }

                    If ((CFGD & 0x20))
                    {
                        If ((CFGD & 0x08))
                        {
                            C3ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C3ST [0x02] = C3LM /* \_PR_.CPU0.C3LM */
                            C3ST [0x03] = C7LM /* \_PR_.CPU0.C7LM */
                            Return (C3ST) /* \_PR_.CPU0.C3ST */
                        }
                        Else
                        {
                            C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C2ST [0x02] = C7LM /* \_PR_.CPU0.C7LM */
                            Return (C2ST) /* \_PR_.CPU0.C2ST */
                        }
                    }

                    If ((CFGD & 0x10))
                    {
                        If ((CFGD & 0x08))
                        {
                            C3ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C3ST [0x02] = C3LM /* \_PR_.CPU0.C3LM */
                            C3ST [0x03] = C6LM /* \_PR_.CPU0.C6LM */
                            Return (C3ST) /* \_PR_.CPU0.C3ST */
                        }
                        Else
                        {
                            C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C2ST [0x02] = C6LM /* \_PR_.CPU0.C6LM */
                            Return (C2ST) /* \_PR_.CPU0.C2ST */
                        }
                    }

                    If ((CFGD & 0x08))
                    {
                        C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                        C2ST [0x02] = C3LM /* \_PR_.CPU0.C3LM */
                        Return (C2ST) /* \_PR_.CPU0.C2ST */
                    }
                    Else
                    {
                        C1ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                        Return (C1ST) /* \_PR_.CPU0.C1ST */
                    }
                }

                If ((CFGD & 0x10))
                {
                    C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                    C2ST [0x02] = C6LM /* \_PR_.CPU0.C6LM */
                    Return (C2ST) /* \_PR_.CPU0.C2ST */
                }
                Else
                {
                    C1ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                    Return (C1ST) /* \_PR_.CPU0.C1ST */
                }
            }

            If (((CFGD & 0x1000) && (PDC0 & 0x0100)))
            {
                If ((!PWRS || (PFLV != FMBL)))
                {
                    If ((CFGD & 0x20))
                    {
                        If ((CFGD & 0x08))
                        {
                            C3ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C3ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                            C3ST [0x03] = C7LI /* \_PR_.CPU0.C7LI */
                            Return (C3ST) /* \_PR_.CPU0.C3ST */
                        }
                        Else
                        {
                            C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C2ST [0x02] = C7LI /* \_PR_.CPU0.C7LI */
                            Return (C2ST) /* \_PR_.CPU0.C2ST */
                        }
                    }

                    If ((CFGD & 0x10))
                    {
                        If ((CFGD & 0x08))
                        {
                            C3ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C3ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                            C3ST [0x03] = C6LI /* \_PR_.CPU0.C6LI */
                            Return (C3ST) /* \_PR_.CPU0.C3ST */
                        }
                        Else
                        {
                            C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                            C2ST [0x02] = C6LI /* \_PR_.CPU0.C6LI */
                            Return (C2ST) /* \_PR_.CPU0.C2ST */
                        }
                    }

                    If ((CFGD & 0x08))
                    {
                        C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                        C2ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                        Return (C2ST) /* \_PR_.CPU0.C2ST */
                    }
                    Else
                    {
                        C1ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                        Return (C1ST) /* \_PR_.CPU0.C1ST */
                    }
                }

                If ((CFGD & 0x10))
                {
                    C2ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                    C2ST [0x02] = C6LI /* \_PR_.CPU0.C6LI */
                    Return (C2ST) /* \_PR_.CPU0.C2ST */
                }
                Else
                {
                    C1ST [0x01] = C1LM /* \_PR_.CPU0.C1LM */
                    Return (C1ST) /* \_PR_.CPU0.C1ST */
                }
            }

            If ((!PWRS || (PFLV != FMBL)))
            {
                If ((CFGD & 0x20))
                {
                    If ((CFGD & 0x08))
                    {
                        C3ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                        C3ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                        C3ST [0x03] = C7LI /* \_PR_.CPU0.C7LI */
                        Return (C3ST) /* \_PR_.CPU0.C3ST */
                    }
                    Else
                    {
                        C2ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                        C2ST [0x02] = C7LI /* \_PR_.CPU0.C7LI */
                        Return (C2ST) /* \_PR_.CPU0.C2ST */
                    }
                }

                If ((CFGD & 0x10))
                {
                    If ((CFGD & 0x08))
                    {
                        C3ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                        C3ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                        C3ST [0x03] = C6LI /* \_PR_.CPU0.C6LI */
                        Return (C3ST) /* \_PR_.CPU0.C3ST */
                    }
                    Else
                    {
                        C2ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                        C2ST [0x02] = C6LI /* \_PR_.CPU0.C6LI */
                        Return (C2ST) /* \_PR_.CPU0.C2ST */
                    }
                }

                If ((CFGD & 0x08))
                {
                    C2ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                    C2ST [0x02] = C3LI /* \_PR_.CPU0.C3LI */
                    Return (C2ST) /* \_PR_.CPU0.C2ST */
                }
                Else
                {
                    C1ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                    Return (C1ST) /* \_PR_.CPU0.C1ST */
                }
            }

            If ((CFGD & 0x10))
            {
                C2ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                C2ST [0x02] = C6LI /* \_PR_.CPU0.C6LI */
                Return (C2ST) /* \_PR_.CPU0.C2ST */
            }
            Else
            {
                C1ST [0x01] = C1LH /* \_PR_.CPU0.C1LH */
                Return (C1ST) /* \_PR_.CPU0.C1ST */
            }
        }
    }
}

