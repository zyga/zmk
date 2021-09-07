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

# Are we using the open Watcom compiler?
Toolchain.CC.IsWatcom=$(if $(findstring watcom,$(Toolchain.cc)),yes)
Toolchain.CXX.IsWatcom=$(if $(findstring watcom,$(Toolchain.cxx)),yes)
Toolchain.IsWatcom=$(and $(Toolchain.CC.IsWatcom),$(Toolchain.CXX.IsWatcom))

# Logic specific to Watcom compiler.
ifneq (,$(Toolchain.CC.IsWatcom))

# Are we building for DOS or 16bit Windows?
ifneq (,$(or $(findstring dos,$(Toolchain.cc)),$(findstring win16,$(Toolchain.cc))))
exe = .exe
Toolchain.CC.ImageFormat = MZ
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because Watcom targets DOS))
endif # !cc win16 || dos

# Are we building for 32bit Windows?
ifneq (,$(findstring win32,$(Toolchain.cc)))
exe = .exe
Toolchain.CC.ImageFormat = PE
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because Watcom targets Windows))
endif # !cc win32
endif # !cc Watcom

# Logic specific to Watcom
ifneq (,$(Toolchain.CXX.IsWatcom))

# Are we building for DOS or 16bit Windows?
ifneq (,$(or $(findstring dos,$(Toolchain.cxx)),$(findstring win16,$(Toolchain.cxx))))
exe = .exe
Toolchain.CXX.ImageFormat = MZ
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because Watcom targets DOS))
endif # !cxx win16 || dos

# Are we building for 32bit Windows?
ifneq (,$(findstring win32,$(Toolchain.cxx)))
exe = .exe
Toolchain.CXX.ImageFormat = PE
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because Watcom targets Windows))
endif # !cxx win32
endif # !cxx Watcom
