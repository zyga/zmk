# Copyright 2019-2021 Zygmunt Krynicki.
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

$(eval $(call ZMK.Import,OS))
$(eval $(call ZMK.Import,Configure))

# Compiler defaults unless changed by config.$(Project.Name).mk

ifeq ($(OS.Kernel),SunOS)
# Solaris doesn't seem to provide any aliases or symlinks for gcc but make wants to call it "cc".
CC := gcc
endif
CPPFLAGS ?=
CFLAGS ?=
CXXFLAGS ?=
OBJCFLAGS ?=
OBJCXXFLAGS ?=
ARFLAGS = -cr
TARGET_ARCH ?=
LDLIBS ?=
LDFLAGS ?=

# The exe variable expands to .exe when the compiled binary should have such suffix.
exe ?=

# Is zmk debugging enabled for this module?
Toolchain.debug ?= $(findstring toolchain,$(DEBUG))

# What is the image format used by the C compiler?
# If we are not cross compiling then image format is native.
Toolchain.CC.ImageFormat ?= $(OS.ImageFormat)

# What is the image format used by the C++ compiler?
Toolchain.CXX.ImageFormat ?= $(OS.ImageFormat)

# Is the C compiler a cross-compiler?
Toolchain.CC.IsCross ?=

# Is the C++ compiler a cross-compiler?
Toolchain.CXX.IsCross ?=

# Should compiling produce dependency information for make?
Toolchain.DependencyTracking ?= $(Configure.DependencyTracking)

# Deduce the kind of the selected compiler. Some build rules or compiler
# options depend on the compiler used. As an alternative we could look at
# preprocessor macros but this way seems sufficient for now.
Toolchain.cc ?= $(shell command -v $(CC) 2>/dev/null)
Toolchain.cxx ?= $(shell command -v $(CXX) 2>/dev/null)

# When CC or CXX point to platform default compiler alias, resolve
# them to the real value, which is better to identify the toolchain.
Toolchain.cc := $(if $(findstring $(Toolchain.cc),/usr/bin/cc),$(realpath $(Toolchain.cc)),$(Toolchain.cc))
Toolchain.cxx := $(if $(findstring $(Toolchain.cxx),/usr/bin/c++ /usr/bin/g++),$(realpath $(Toolchain.cxx)),$(Toolchain.cxx))

# Is the C and C++ compiler really available?
Toolchain.CC.IsAvailable ?= $(if $(wildcard $(realpath $(Toolchain.cc))),yes)
Toolchain.CXX.IsAvailable ?= $(if $(wildcard $(realpath $(Toolchain.cxx))),yes)

# What is the version string of the C and the C++ compilers?
Toolchain.cc.version ?= $(if $(Toolchain.CC.IsAvailable),$(shell $(Toolchain.cc) --version))
Toolchain.cxx.version ?= $(if $(Toolchain.CXX.IsAvailable),$(shell $(Toolchain.cxx) --version))

# Import toolchain-specific knowledge.
$(eval $(call ZMK.Import,toolchain.GCC))
$(eval $(call ZMK.Import,toolchain.Clang))
$(eval $(call ZMK.Import,toolchain.Watcom))
$(eval $(call ZMK.Import,toolchain.Tcc))

# Is either the C or C++ compiler a cross compiler?
Toolchain.IsCross ?= $(or $(Toolchain.CC.IsCross),$(Toolchain.CXX.IsCross))

# Is the image format between C and C++ uniform?
ifeq ($(Toolchain.CC.ImageFormat),$(Toolchain.CXX.ImageFormat))
Toolchain.ImageFormat = $(Toolchain.CC.ImageFormat)
else
Toolchain.ImageFormat = Mixed
endif

# If dependency tracking is enabled, pass extra options to the compiler, to
# generate dependency data at the same time as compiling object files.
ifneq (,$(and $(Toolchain.DependencyTracking),$(or $(Toolchain.IsGcc),$(Toolchain.IsClang))))
%.o: CPPFLAGS += -MMD$(if $(ZMK.IsOutOfTreeBuild), -MF $(@:.o=.d))
$(if $(Toolchain.debug),$(info DEBUG: compiling object files will generate make dependency information))
endif

$(if $(Toolchain.debug),$(foreach v,CC CXX CPP CFLAGS CXXFLAGS CPPFLAGS OBJCFLAGS OBJCXXFLAGS ARFLAGS TARGET_ARCH LDLIBS LDFLAGS $(sort $(filter Toolchain.%,$(.VARIABLES))),$(info DEBUG: $v=$($v))))
