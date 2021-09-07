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

# Is zmk debugging enabled for this module?
Silent.Active?=
ifeq (,$(value ZMK.testing))
Silent.Command=$(if $(Silent.Active),@)
else
# ZMK is being tested, mainly, by running make -n and measuring the output.
# Make ignores the non-echo rule when -n is in effect. As such, to improve
# testing of silent rules, when zmk is being tested pretend all silent rules
# are commented-out shell commands. This can be readily verified by simple grep
# patterns.
Silent.Command=$(if $(Silent.Active),$(ZMK.hash))
endif
Silent.Say=$(if $(Silent.Active),@printf "  %-16s %s\n" "$1" "$2")
