# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.


# Are we using GCC?
Toolchain.CC.IsGcc=$(if $(findstring gcc,$(Toolchain.cc)),yes)
Toolchain.CXX.IsGcc=$(if $(and $(if $(findstring clang++,$(Toolchain.cxx)),,not-clang++),$(findstring g++,$(Toolchain.cxx))),yes)
Toolchain.IsGcc=$(and $(Toolchain.CC.IsGcc),$(Toolchain.CXX.IsGcc))

# Logic specific to gcc
ifneq (,$(Toolchain.CC.IsGcc))

# If we are configured then check for cross compilation by mismatch of host and
# build triplets. When this happens set CC. This is important for
# autoconf/automake compatibility.
ifneq (,$(and $(Configure.Configured),$(Configure.HostArchTriplet),$(Configure.BuildArchTriplet)))
ifneq ($(Configure.BuildArchTriplet),$(Configure.HostArchTriplet))
ifeq ($(origin CC),default)
CC = $(Configure.HostArchTriplet)-gcc
$(if $(Toolchain.debug),$(info DEBUG: gcc cross-compiler selected CC=$(CC)))
endif # !default CC
endif # !cross-compiling
endif # !configured

# Indirection for testability.
Toolchain.gcc ?= $(shell command -v gcc 2>/dev/null)
Toolchain.cc.dumpmachine  ?= $(shell $(CC)  -dumpmachine)
Toolchain.gcc.dumpmachine ?= $(if $(Toolchain.gcc),$(shell gcc    -dumpmachine))

# Are we targeting Windows with mingw?
ifneq (,$(findstring mingw,$(Toolchain.cc.dumpmachine)))
exe = .exe
Toolchain.CC.ImageFormat = PE
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) -dumpmachine mentions mingw))
endif # !mingw

# Are we targeting Linux?
ifneq (,$(findstring linux,$(Toolchain.cc.dumpmachine)))
Toolchain.CC.ImageFormat = ELF
endif # !linux

# Is gcc cross-compiling?
ifneq ($(Toolchain.gcc.dumpmachine),$(Toolchain.cc.dumpmachine))
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because gcc -dumpmachine and $(CC) -dumpmachine differ))
endif # !cross
endif # !cc=gcc


# Logic specific to g++
ifneq (,$(Toolchain.CXX.IsGcc))

# If we are configured then check for cross compilation by mismatch of host and
# build triplets. When this happens set CXX. This is important for
# autoconf/automake compatibility.
ifneq (,$(and $(Configure.Configured),$(Configure.HostArchTriplet),$(Configure.BuildArchTriplet)))
ifneq ($(Configure.BuildArchTriplet),$(Configure.HostArchTriplet))
ifeq ($(origin CXX),default)
CXX = $(Configure.HostArchTriplet)-g++
$(if $(Toolchain.debug),$(info DEBUG: g++ cross-compiler selected CXX=$(CXX)))
endif # !default CXX
endif # !cross-compiling
endif # !configured

# Indirection for testability.
Toolchain.g++ ?= $(shell command -v g++ 2>/dev/null)
Toolchain.cxx.dumpmachine ?= $(shell $(CXX) -dumpmachine)
Toolchain.g++.dumpmachine ?= $(if $(Toolchain.g++),$(shell g++    -dumpmachine))

# Are we targeting Windows with mingw?
ifneq (,$(findstring mingw,$(Toolchain.cxx.dumpmachine)))
exe = .exe
Toolchain.CXX.ImageFormat = PE
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) -dumpmachine mentions mingw))
endif # !mingw

# Are we targeting Linux?
ifneq (,$(findstring linux,$(Toolchain.cxx.dumpmachine)))
Toolchain.CXX.ImageFormat = ELF
endif # !linux

# Is g++ cross compiling?
ifneq ($(Toolchain.g++.dumpmachine),$(Toolchain.cxx.dumpmachine))
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because g++ -dumpmachine and $(CXX) -dumpmachine differ))
endif # !cross
endif # !cxx=gcc
