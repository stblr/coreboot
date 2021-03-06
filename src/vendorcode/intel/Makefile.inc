## SPDX-License-Identifier: GPL-2.0-only

ifeq ($(CONFIG_UEFI_2_4_BINDING),y)
# ProccessorBind.h provided in Ia32 directory. Types are derived from ia32.
# It's possible to provide our own ProcessorBind.h using posix types. However,
# ProcessorBind.h isn't just about types. There's compiler definitions as well
# as ABI enforcement. Luckily long is not used in Ia32/ProcessorBind.h for
# a fixed width type.
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/uefi_2.4/MdePkg/Include/Ia32
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/uefi_2.4/MdePkg/Include
else ifeq ($(CONFIG_UDK_2015_BINDING),y)
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2015/MdePkg/Include/Ia32
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2015/MdePkg/Include
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2015/IntelFsp2Pkg/Include
else ifeq ($(CONFIG_UDK_2017_BINDING),y)
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2017/MdePkg/Include/Ia32
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2017/MdePkg/Include
CPPFLAGS_common += -I$(src)/vendorcode/intel/edk2/UDK2017/IntelFsp2Pkg/Include
endif
