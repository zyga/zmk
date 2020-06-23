#!/usr/bin/make -f
include zmk/internalTest.mk

t:: debug-linux debug-freebsd debug-openbsd debug-netbsd \
	debug-hurd debug-gnu-kfreebsd debug-solaris \
	debug-darwin debug-windows debug-haiku debug-unknown

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=os

debug-linux.log: ZMK.makeOverrides += OS.Kernel=Linux
debug-linux: debug-linux.log
	MATCH -qF 'DEBUG: OS.Kernel=Linux' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-freebsd.log: ZMK.makeOverrides += OS.Kernel=FreeBSD
debug-freebsd: debug-freebsd.log
	MATCH -qF 'DEBUG: OS.Kernel=FreeBSD' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-openbsd.log: ZMK.makeOverrides += OS.Kernel=OpenBSD
debug-openbsd: debug-openbsd.log
	MATCH -qF 'DEBUG: OS.Kernel=OpenBSD' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-netbsd.log: ZMK.makeOverrides += OS.Kernel=NetBSD
debug-netbsd: debug-netbsd.log
	MATCH -qF 'DEBUG: OS.Kernel=NetBSD' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-hurd.log: ZMK.makeOverrides += OS.Kernel=GNU
debug-hurd: debug-hurd.log
	MATCH -qF 'DEBUG: OS.Kernel=GNU' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-gnu-kfreebsd.log: ZMK.makeOverrides += OS.Kernel=GNU/kFreeBSD
debug-gnu-kfreebsd: debug-gnu-kfreebsd.log
	MATCH -qF 'DEBUG: OS.Kernel=GNU/kFreeBSD' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-solaris.log: ZMK.makeOverrides += OS.Kernel=SunOS
debug-solaris: debug-solaris.log
	MATCH -qF 'DEBUG: OS.Kernel=SunOS' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-darwin.log: ZMK.makeOverrides += OS.Kernel=Darwin
debug-darwin: debug-darwin.log
	MATCH -qF 'DEBUG: OS.Kernel=Darwin' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=Mach-O' <$<

debug-windows.log: export OS=Windows_NT
debug-windows: debug-windows.log
	MATCH -qF 'DEBUG: OS.Kernel=Windows_NT' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=PE' <$<

debug-haiku.log: ZMK.makeOverrides += OS.Kernel=Haiku
debug-haiku: debug-haiku.log
	MATCH -qF 'DEBUG: OS.Kernel=Haiku' <$<
	MATCH -qF 'DEBUG: OS.ImageFormat=ELF' <$<

debug-unknown.log: ZMK.makeOverrides += OS.Kernel=Unknown
debug-unknown: debug-unknown.log
	MATCH -Eq '[*]{3} unsupported operating system kernel Unknown\.' <$<
