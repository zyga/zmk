#!/usr/bin/make -f
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

# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all

$(eval $(ZMK.isolateHostToolchain))

all: all.log
	GREP -qFx 'cc -DEXIT_CODE=EXIT_SUCCESS -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF true-true_false.d) -c -o true-true_false.o $(ZMK.test.OutOfTreeSourcePath)true_false.c' <$<
	GREP -qFx 'cc -o true true-true_false.o' <$<
	GREP -qFx 'cc -DEXIT_CODE=EXIT_FAILURE -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF false-true_false.d) -c -o false-true_false.o $(ZMK.test.OutOfTreeSourcePath)true_false.c' <$<
	GREP -qFx 'cc -o false false-true_false.o' <$<
