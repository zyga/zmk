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

t:: run-shellcheck GREP-pass GREP-fail GREP-redirect

run-shellcheck:
	# If we have shellcheck, then GREP should pass it without issues.
	if [ -n "$$(command -v shellcheck)" ]; then shellcheck $(ZMK.test.Path)/tests/bin/GREP; fi

GREP-pass:
	# When GREP finds a match, the result is success.
	echo "marry had a little lamb" | GREP lamb

GREP-fail:
	# When GREP dose not find a match, the result is failure.
	! echo "marry had a little lamb" | GREP fox >/dev/null
	# The failure is accompanied by details of the failure.
	echo "marry had a little lamb" | GREP fox | grep -qFx 'GREP: failed to match: grep "fox"'
	# If the input is a one-liner it is printed this way.
	echo "marry had a little lamb" | GREP fox | grep -qFx 'GREP: for input "marry had a little lamb"'
	# If the input is longer, it is printed verbatim.
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "GREP: input starts below:"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "marry had"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "a little lamb"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "GREP: input ends above."
	# The printed error output is correctly escaped.
	echo '"this is one thing"' | GREP that | grep -qFx 'GREP: for input "\"this is one thing\""'
	echo 'dollar is $$' | GREP cent | grep -qFx 'GREP: for input "dollar is \$$"'

GREP-redirect: export LC_ALL=C
GREP-redirect:
	# GREP, if invoked as the lower-case grep, redirects back to system grep.
	# Note that GREP describes itself as upper-case GREP in the usage string.
	./grep 2>&1 | grep -q '[Uu]sage: grep'
