#!/usr/bin/make -f
include zmk/internalTest.mk

t:: debug-linux debug-freebsd debug-openbsd debug-netbsd \
	debug-hurd debug-gnu-kfreebsd debug-solaris \
	debug-darwin debug-windows debug-haiku debug-unknown

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=os

debug-linux.log: ZMK.makeOverrides += OS.Kernel=Linux
debug-linux: debug-linux.log
	GREP -qF 'DEBUG: OS.Kernel=Linux' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-freebsd.log: ZMK.makeOverrides += OS.Kernel=FreeBSD
debug-freebsd: debug-freebsd.log
	GREP -qF 'DEBUG: OS.Kernel=FreeBSD' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-openbsd.log: ZMK.makeOverrides += OS.Kernel=OpenBSD
debug-openbsd: debug-openbsd.log
	GREP -qF 'DEBUG: OS.Kernel=OpenBSD' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-netbsd.log: ZMK.makeOverrides += OS.Kernel=NetBSD
debug-netbsd: debug-netbsd.log
	GREP -qF 'DEBUG: OS.Kernel=NetBSD' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-hurd.log: ZMK.makeOverrides += OS.Kernel=GNU
debug-hurd: debug-hurd.log
	GREP -qF 'DEBUG: OS.Kernel=GNU' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-gnu-kfreebsd.log: ZMK.makeOverrides += OS.Kernel=GNU/kFreeBSD
debug-gnu-kfreebsd: debug-gnu-kfreebsd.log
	GREP -qF 'DEBUG: OS.Kernel=GNU/kFreeBSD' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-solaris.log: ZMK.makeOverrides += OS.Kernel=SunOS
debug-solaris: debug-solaris.log
	GREP -qF 'DEBUG: OS.Kernel=SunOS' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-darwin.log: ZMK.makeOverrides += OS.Kernel=Darwin
debug-darwin: debug-darwin.log
	GREP -qF 'DEBUG: OS.Kernel=Darwin' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=Mach-O' <$<

debug-windows.log: export OS=Windows_NT
debug-windows: debug-windows.log
	GREP -qF 'DEBUG: OS.Kernel=Windows_NT' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=PE' <$<

debug-haiku.log: ZMK.makeOverrides += OS.Kernel=Haiku
debug-haiku: debug-haiku.log
	GREP -qF 'DEBUG: OS.Kernel=Haiku' <$<
	GREP -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-unknown.log: ZMK.makeOverrides += OS.Kernel=Unknown
debug-unknown: debug-unknown.log
	GREP -Eq '[*]{3} unsupported operating system kernel Unknown\.' <$<
