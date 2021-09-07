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

t:: all install uninstall clean check

all: all.log
	GREP -q "Nothing to be done for [\`']all'\." <$<
install: install.log
	GREP -qF 'install -d /usr/local/bin' <$<
	GREP -qF 'install -m 0755 $(ZMK.test.OutOfTreeSourcePath)hello.sh /usr/local/bin/hello.sh' <$<
uninstall: uninstall.log
	GREP -qF 'rm -f /usr/local/bin/hello.sh' <$<
clean: clean.log
	GREP -q "Nothing to be done for [\`']clean'\." <$<
check: check-with-shellcheck check-without-shellcheck
check-with-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=shellcheck
check-with-shellcheck: check-with-shellcheck.log
	GREP -qF 'shellcheck $(ZMK.test.OutOfTreeSourcePath)hello.sh' <$<
check-without-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=
check-without-shellcheck: check-without-shellcheck.log
	GREP -qF 'echo "ZMK: install shellcheck to analyze $(ZMK.test.OutOfTreeSourcePath)hello.sh"' <$<
