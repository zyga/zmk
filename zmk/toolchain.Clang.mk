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

# Are we using Clang?
Toolchain.CC.IsClang?=$(if $(or $(findstring clang,$(Toolchain.cc)),$(findstring clang,$(Toolchain.cc.version))),yes)
Toolchain.CXX.IsClang?=$(if $(or $(findstring clang,$(Toolchain.cxx)),$(findstring clang,$(Toolchain.cxx.version))),yes)
Toolchain.IsClang?=$(and $(Toolchain.CC.IsClang),$(Toolchain.CXX.IsClang))
# TODO: handle cross compiling with clang.
