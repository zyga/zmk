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

include z.mk

prog1.Sources = main.c
$(eval $(call ZMK.Expand,Program,prog1))
prog2.Sources = main.cpp
$(eval $(call ZMK.Expand,Program,prog2))
prog3.Sources = main.m
$(eval $(call ZMK.Expand,Program,prog3))
# Alternative C++ extensions
prog4.Sources = main.cxx
$(eval $(call ZMK.Expand,Program,prog4))
prog5.Sources = main.cc
$(eval $(call ZMK.Expand,Program,prog5))
# Source code can be in arbitrary tree structure.
prog6.Sources = src/main.c
$(eval $(call ZMK.Expand,Program,prog6))
# The binary can be in arbitrary tree structure.
subdir/prog7.Sources = main.c
$(eval $(call ZMK.Expand,Program,subdir/prog7))
