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

t:: debug-linux debug-freebsd debug-openbsd debug-netbsd \
	debug-hurd debug-gnu-kfreebsd debug-solaris \
	debug-darwin debug-windows debug-haiku debug-unknown

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=os

debug-linux.log: ZMK.makeOverrides += OS.Kernel=Linux
debug-linux: debug-linux.log
	GREP -qFx 'DEBUG: OS.Kernel=Linux' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-freebsd.log: ZMK.makeOverrides += OS.Kernel=FreeBSD
debug-freebsd: debug-freebsd.log
	GREP -qFx 'DEBUG: OS.Kernel=FreeBSD' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-openbsd.log: ZMK.makeOverrides += OS.Kernel=OpenBSD
debug-openbsd: debug-openbsd.log
	GREP -qFx 'DEBUG: OS.Kernel=OpenBSD' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-netbsd.log: ZMK.makeOverrides += OS.Kernel=NetBSD
debug-netbsd: debug-netbsd.log
	GREP -qFx 'DEBUG: OS.Kernel=NetBSD' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-hurd.log: ZMK.makeOverrides += OS.Kernel=GNU
debug-hurd: debug-hurd.log
	GREP -qFx 'DEBUG: OS.Kernel=GNU' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-gnu-kfreebsd.log: ZMK.makeOverrides += OS.Kernel=GNU/kFreeBSD
debug-gnu-kfreebsd: debug-gnu-kfreebsd.log
	GREP -qFx 'DEBUG: OS.Kernel=GNU/kFreeBSD' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-solaris.log: ZMK.makeOverrides += OS.Kernel=SunOS
debug-solaris: debug-solaris.log
	GREP -qFx 'DEBUG: OS.Kernel=SunOS' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-darwin.log: ZMK.makeOverrides += OS.Kernel=Darwin
debug-darwin: debug-darwin.log
	GREP -qFx 'DEBUG: OS.Kernel=Darwin' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=Mach-O' <$<

debug-windows.log: export OS=Windows_NT
debug-windows: debug-windows.log
	GREP -qFx 'DEBUG: OS.Kernel=Windows_NT' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=PE' <$<

debug-haiku.log: ZMK.makeOverrides += OS.Kernel=Haiku
debug-haiku: debug-haiku.log
	GREP -qFx 'DEBUG: OS.Kernel=Haiku' <$<
	GREP -qFx 'DEBUG: OS.ImageFormat=ELF' <$<

debug-unknown.log: ZMK.makeOverrides += OS.Kernel=Unknown
debug-unknown: debug-unknown.log
	GREP -Eq '[*]{3} unsupported operating system kernel Unknown\.' <$<
