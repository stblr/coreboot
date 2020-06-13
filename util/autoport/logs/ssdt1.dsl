/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200430 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt1.dat, Sat Jun 13 11:38:38 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000009B1 (2481)
 *     Revision         0x01
 *     Checksum         0x92
 *     OEM ID           "PmRef"
 *     OEM Table ID     "CpuPm"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20060912 (537266450)
 */
DefinitionBlock ("", "SSDT", 1, "PmRef", "CpuPm", 0x00003000)
{
    External (_PR_.CPU0, ProcessorObj)
    External (_PR_.CPU1, ProcessorObj)
    External (_PR_.CPU2, ProcessorObj)
    External (_PR_.CPU3, ProcessorObj)
    External (_PR_.CPU4, ProcessorObj)
    External (_PR_.CPU5, ProcessorObj)
    External (_PR_.CPU6, ProcessorObj)
    External (_PR_.CPU7, ProcessorObj)

    Scope (\)
    {
        Name (SSDT, Package (0x0C)
        {
            "CPU0IST ", 
            0xBA738018, 
            0x000007CE, 
            "APIST   ", 
            0xBCE6BA98, 
            0x00000303, 
            "CPU0CST ", 
            0xBCE6A718, 
            0x0000069C, 
            "APCST   ", 
            0xBCE69D98, 
            0x00000119
        })
        Name (CFGD, 0x0076F6FF)
        Name (\PDC0, 0x80000000)
        Name (\PDC1, 0x80000000)
        Name (\PDC2, 0x80000000)
        Name (\PDC3, 0x80000000)
        Name (\PDC4, 0x80000000)
        Name (\PDC5, 0x80000000)
        Name (\PDC6, 0x80000000)
        Name (\PDC7, 0x80000000)
        Name (\SDTL, 0x00)
    }

    Scope (\_PR.CPU0)
    {
        Name (HI0, 0x00)
        Name (HC0, 0x00)
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (CPDC, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, REVS)
            CreateDWordField (Arg0, 0x04, SIZE)
            Local0 = SizeOf (Arg0)
            Local1 = (Local0 - 0x08)
            CreateField (Arg0, 0x40, (Local1 * 0x08), TEMP)
            Name (STS0, Buffer (0x04)
            {
                 0x00, 0x00, 0x00, 0x00                           // ....
            })
            Concatenate (STS0, TEMP, Local2)
            Return (COSC (ToUUID ("4077a616-290c-47be-9ebd-d87058713953"), REVS, SIZE, Local2))
        }

        Method (COSC, 4, NotSerialized)
        {
            CreateDWordField (Arg3, 0x00, STS0)
            CreateDWordField (Arg3, 0x04, CAP0)
            CreateDWordField (Arg0, 0x00, IID0)
            CreateDWordField (Arg0, 0x04, IID1)
            CreateDWordField (Arg0, 0x08, IID2)
            CreateDWordField (Arg0, 0x0C, IID3)
            Name (UID0, ToUUID ("4077a616-290c-47be-9ebd-d87058713953"))
            CreateDWordField (UID0, 0x00, EID0)
            CreateDWordField (UID0, 0x04, EID1)
            CreateDWordField (UID0, 0x08, EID2)
            CreateDWordField (UID0, 0x0C, EID3)
            If (!(((IID0 == EID0) && (IID1 == EID1)) && ((
                IID2 == EID2) && (IID3 == EID3))))
            {
                STS0 = 0x06
                Return (Arg3)
            }

            If ((Arg1 != 0x01))
            {
                STS0 = 0x0A
                Return (Arg3)
            }

            Return (Arg3)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS0)
            CreateDWordField (Arg0, 0x04, CAP0)
            If (((STS0 == 0x06) || (STS0 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS0 & 0x01))
            {
                CAP0 &= 0x0BFF
                Return (Zero)
            }

            PDC0 = ((PDC0 & 0x7FFFFFFF) | CAP0) /* \_PR_.CPU0.GCAP.CAP0 */
            If ((CFGD & 0x3E))
            {
                If ((((CFGD & 0x0400) && (PDC0 & 0x18)) && !
                    (SDTL & 0x02)))
                {
                    SDTL |= 0x02
                    OperationRegion (CST0, SystemMemory, DerefOf (SSDT [0x07]), DerefOf (SSDT [0x08]))
                    Load (CST0, HC0) /* \_PR_.CPU0.HC0_ */
                }
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU1)
    {
        Name (HI1, 0x00)
        Name (HC1, 0x00)
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS1)
            CreateDWordField (Arg0, 0x04, CAP1)
            If (((STS1 == 0x06) || (STS1 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS1 & 0x01))
            {
                CAP1 &= 0x0BFF
                Return (Zero)
            }

            PDC1 = ((PDC1 & 0x7FFFFFFF) | CAP1) /* \_PR_.CPU1.GCAP.CAP1 */
            If (((PDC0 & 0x09) == 0x09))
            {
                APPT ()
            }

            If ((PDC0 & 0x18))
            {
                APCT ()
            }

            Return (Zero)
        }

        Method (APCT, 0, NotSerialized)
        {
            If (((CFGD & 0x2E) && !(SDTL & 0x20)))
            {
                SDTL |= 0x20
                OperationRegion (CST1, SystemMemory, DerefOf (SSDT [0x0A]), DerefOf (SSDT [0x0B]))
                Load (CST1, HC1) /* \_PR_.CPU1.HC1_ */
            }
        }

        Method (APPT, 0, NotSerialized)
        {
            If (((CFGD & 0x01) && !(SDTL & 0x10)))
            {
                SDTL |= 0x10
                OperationRegion (IST1, SystemMemory, DerefOf (SSDT [0x04]), DerefOf (SSDT [0x05]))
                Load (IST1, HI1) /* \_PR_.CPU1.HI1_ */
            }
        }
    }

    Scope (\_PR.CPU2)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS2)
            CreateDWordField (Arg0, 0x04, CAP2)
            If (((STS2 == 0x06) || (STS2 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS2 & 0x01))
            {
                CAP2 &= 0x0BFF
                Return (Zero)
            }

            PDC2 = ((PDC2 & 0x7FFFFFFF) | CAP2) /* \_PR_.CPU2.GCAP.CAP2 */
            If (((PDC2 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC2 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU3)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS3)
            CreateDWordField (Arg0, 0x04, CAP3)
            If (((STS3 == 0x06) || (STS3 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS3 & 0x01))
            {
                CAP3 &= 0x0BFF
                Return (Zero)
            }

            PDC3 = ((PDC3 & 0x7FFFFFFF) | CAP3) /* \_PR_.CPU3.GCAP.CAP3 */
            If (((PDC3 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC3 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU4)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS4)
            CreateDWordField (Arg0, 0x04, CAP4)
            If (((STS4 == 0x06) || (STS4 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS4 & 0x01))
            {
                CAP4 &= 0x0BFF
                Return (Zero)
            }

            PDC4 = ((PDC4 & 0x7FFFFFFF) | CAP4) /* \_PR_.CPU4.GCAP.CAP4 */
            If (((PDC4 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC4 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU5)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS5)
            CreateDWordField (Arg0, 0x04, CAP5)
            If (((STS5 == 0x06) || (STS5 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS5 & 0x01))
            {
                CAP5 &= 0x0BFF
                Return (Zero)
            }

            PDC5 = ((PDC5 & 0x7FFFFFFF) | CAP5) /* \_PR_.CPU5.GCAP.CAP5 */
            If (((PDC5 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC5 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU6)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS6)
            CreateDWordField (Arg0, 0x04, CAP6)
            If (((STS6 == 0x06) || (STS6 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS6 & 0x01))
            {
                CAP6 &= 0x0BFF
                Return (Zero)
            }

            PDC6 = ((PDC6 & 0x7FFFFFFF) | CAP6) /* \_PR_.CPU6.GCAP.CAP6 */
            If (((PDC6 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC6 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }

    Scope (\_PR.CPU7)
    {
        Method (_PDC, 1, NotSerialized)  // _PDC: Processor Driver Capabilities
        {
            Local0 = \_PR.CPU0.CPDC (Arg0)
            GCAP (Local0)
            Return (Local0)
        }

        Method (_OSC, 4, NotSerialized)  // _OSC: Operating System Capabilities
        {
            Local0 = \_PR.CPU0.COSC (Arg0, Arg1, Arg2, Arg3)
            GCAP (Local0)
            Return (Local0)
        }

        Method (GCAP, 1, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, STS7)
            CreateDWordField (Arg0, 0x04, CAP7)
            If (((STS7 == 0x06) || (STS7 == 0x0A)))
            {
                Return (Zero)
            }

            If ((STS7 & 0x01))
            {
                CAP7 &= 0x0BFF
                Return (Zero)
            }

            PDC7 = ((PDC7 & 0x7FFFFFFF) | CAP7) /* \_PR_.CPU7.GCAP.CAP7 */
            If (((PDC7 & 0x09) == 0x09))
            {
                \_PR.CPU1.APPT ()
            }

            If ((PDC7 & 0x18))
            {
                \_PR.CPU1.APCT ()
            }

            Return (Zero)
        }
    }
}

