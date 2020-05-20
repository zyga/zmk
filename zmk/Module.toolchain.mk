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

$(eval $(call import,Module.OS))

# Compiler defaults unless changed by GNUmakefile.configure.mk
CPPFLAGS ?=
CFLAGS ?=
CXXFLAGS ?=
OBJCFLAGS ?=
ARFLAGS = -cr
TARGET_ARCH ?=
LDLIBS ?=
LDFLAGS ?=

# xcrun is the helper for accessing toolchain programs on MacOS
# It is defined as empty for non-Darwin build environments.
xcrun ?=

ifeq ($(OS),Darwin)
# MacOS uses xcrun helper for some toolchain binaries.
xcrun := xcrun
endif

# Deduce the kind of the selected compiler. Some build rules or compiler
# options depend on the compiler used. As an alternative we could look at
# preprocessor macros but this way seems sufficient for now.
Toolchain._cc := $(shell sh -c "command -v $(CC)")
ifeq ($(Toolchain._cc),/usr/bin/cc)
Toolchain._cc := $(realpath $(Toolchain._cc))
endif
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain._cc=$(Toolchain._cc)))
# Is CC the gcc compiler?
Toolchain.is_gcc=$(if $(findstring gcc,$(Toolchain._cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain.is_gcc=$(Toolchain.is_gcc)))
# Is CC the clang compiler?
Toolchain.is_clang=$(if $(findstring clang,$(Toolchain._cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain.is_clang=$(Toolchain.is_clang)))
# Is CC the open-watcom compiler?
Toolchain.is_watcom=$(if $(findstring watcom,$(Toolchain._cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain.is_watcom=$(Toolchain.is_watcom)))
# Is CC the open-watcom compiler targeting a DOS/Windows target.
Toolchain.is_watcom_exe=$(if $(or $(findstring dos,$(Toolchain._cc)),$(findstring win,$(Toolchain._cc))),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain.is_watcom_exe=$(Toolchain.is_watcom_exe)))
# Is CC the tcc compiler?
Toolchain.is_tcc=$(if $(findstring tcc,$(_cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: Toolchain.is_tcc=$(Toolchain.is_tcc)))

# The exe variable expands to .exe when the compiled binary should have such suffix.
exe ?=
ifeq ($(Toolchain.is_watcom_exe),yes)
exe = .exe
endif

# If cross-compiling, this is non-empty.
Toolchain.Cross ?=
