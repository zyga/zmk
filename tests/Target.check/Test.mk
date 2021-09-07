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

include zmk/internalTest.mk

t:: check static-check

check: check.log
	# The check target depends on static-check
	GREP -qFx 'echo "target :check:"' <$<
	GREP -qFx 'echo "target :static-check:"' <$<

# internalTest.mk uses dashes to separate targets and
# cannot deduce a target that uses dashes itself.
# Provide the target explicitly with override.
static-check.log: ZMK.makeTarget=static-check
static-check: static-check.log
	# The static check target runs just the static checks.
	GREP -qFx 'echo "target :static-check:"' <$<
	GREP -v -qFx 'echo "target :check:"' <$<
