# Copyright 2019-2020 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

# Is zmk debugging enabled for this module?
OS.debug ?= $(findstring os,$(DEBUG))

# OS.Kernel is the name of the operating system kernel.
# There are multiple possibilities but most common include
# Linux, Darwin and Windows_NT.
ifeq ($(origin OS),environment)
OS.Kernel = $(findstring $(OS),Windows_NT)
else
OS.Kernel := $(shell uname -s)
endif

# Format of the executables used by the OS.
# In general all systems fall into one of the three
# possible formats: ELF, Mach-O, PE and MZ (though unlikely).
# Many UNIX systems, apart from Darwin, use elf.
ifneq (,$(findstring $(OS.Kernel),Linux FreeBSD NetBSD OpenBSD GNU GNU/kFreeBSD SunOS Haiku))
OS.ImageFormat = ELF
endif
ifeq ($(OS.Kernel),Darwin)
OS.ImageFormat = Mach-O
endif
ifeq ($(OS.Kernel),Windows_NT)
OS.ImageFormat = PE
endif
OS.ImageFormat ?= $(error unsupported operating system kernel $(OS.Kernel))

$(if $(OS.debug),$(info DEBUG: OS.Kernel=$(OS.Kernel)))
$(if $(OS.debug),$(info DEBUG: OS.ImageFormat=$(OS.ImageFormat)))
