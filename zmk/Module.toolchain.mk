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
_cc := $(shell sh -c "command -v $(CC)")
ifeq ($(_cc),/usr/bin/cc)
_cc := $(realpath $(_cc))
endif
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: _cc=$(_cc)))
is_gcc=$(if $(findstring gcc,$(_cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: is_gcc=$(is_gcc)))
is_clang=$(if $(findstring clang,$(_cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: is_clang=$(is_clang)))
is_watcom=$(if $(findstring watcom,$(_cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: is_watcom=$(is_watcom)))
is_watcom_exe=$(if $(or $(findstring dos,$(_cc)),$(findstring win,$(_cc))),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: is_watcom_exe=$(is_watcom_exe)))
is_tcc=$(if $(findstring tcc,$(_cc)),yes)
$(if $(findstring toolchain,$(DEBUG)),$(info DEBUG: is_tcc=$(is_tcc)))

exe ?=
ifeq ($(is_watcom_exe),yes)
exe = .exe
endif

# If cross-compiling, this is non-empty.
Toolchain.Cross ?=

# Remove object files when cleaning.
clean::
	rm -f *.o
