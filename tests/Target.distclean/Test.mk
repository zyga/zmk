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

t:: clean distclean

clean: clean.log
	# The clean target run the clean but not the distclean command.
	GREP -qFx 'echo "target :clean:"' <$<
	GREP -v -qFx 'echo "target :distclean:"' <$<

distclean: distclean.log
	# The distclean target run both the clean and the distclean command.
	GREP -qFx 'echo "target :clean:"' <$<
	GREP -qFx 'echo "target :distclean:"' <$<
