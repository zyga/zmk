#!/usr/bin/make -f
include zmk/internalTest.mk

t:: debug-defaults debug-name-defined debug-destdir debug-prefix \
	debug-sysconfdir debug-libexecdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directories,directory

debug-defaults: debug-defaults.log
	GREP -qFx 'DEBUG: prefix=/usr/local' <$<
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -d /usr/local/sbin' <$<
	GREP -qFx 'install -d /usr/local/libexec' <$<
	GREP -qFx 'install -d /usr/local/share' <$<
	GREP -qFx 'install -d /usr/local/etc' <$<
	GREP -qFx 'install -d /usr/local/com' <$<
	GREP -qFx 'install -d /usr/local/var' <$<
	GREP -qFx 'install -d /usr/local/var/run' <$<
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -d /usr/local/shareinfo' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -d /usr/local/share/locale' <$<
	GREP -qFx 'install -d /usr/local/share/man' <$<
	GREP -qFx 'install -d /usr/local/share/man/man1' <$<
	GREP -qFx 'install -d /usr/local/share/man/man2' <$<
	GREP -qFx 'install -d /usr/local/share/man/man3' <$<
	GREP -qFx 'install -d /usr/local/share/man/man4' <$<
	GREP -qFx 'install -d /usr/local/share/man/man5' <$<
	GREP -qFx 'install -d /usr/local/share/man/man6' <$<
	GREP -qFx 'install -d /usr/local/share/man/man7' <$<
	GREP -qFx 'install -d /usr/local/share/man/man8' <$<
	GREP -qFx 'install -d /usr/local/share/man/man9' <$<

debug-silent-rules.log: ZMK.makeOverrides += Silent.Active=yes
debug-silent-rules: debug-silent-rules.log
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr"' <$<

debug-name-defined.log: ZMK.makeOverrides += NAME=test
debug-name-defined: debug-name-defined.log
	GREP -qFx 'install -d /usr/local/share/doc/test' <$<

debug-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
debug-destdir: debug-destdir.log
	GREP -qFx 'DEBUG: prefix=/usr/local' <$<
	GREP -qFx 'DEBUG: DESTDIR=/destdir' <$<
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr/local' <$<
	GREP -qFx 'install -d /destdir/usr/local/bin' <$<
	GREP -qFx 'install -d /destdir/usr/local/sbin' <$<
	GREP -qFx 'install -d /destdir/usr/local/libexec' <$<
	GREP -qFx 'install -d /destdir/usr/local/share' <$<
	GREP -qFx 'install -d /destdir/usr/local/etc' <$<
	GREP -qFx 'install -d /destdir/usr/local/com' <$<
	GREP -qFx 'install -d /destdir/usr/local/var' <$<
	GREP -qFx 'install -d /destdir/usr/local/var/run' <$<
	GREP -qFx 'install -d /destdir/usr/local/include' <$<
	GREP -qFx 'install -d /destdir/usr/local/shareinfo' <$<
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/locale' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man1' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man2' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man3' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man4' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man5' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man6' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man7' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man8' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man9' <$<

debug-prefix.log: ZMK.makeOverrides += prefix=/usr
debug-prefix: debug-prefix.log
	GREP -qFx 'DEBUG: prefix=/usr' <$<
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/bin' <$<
	GREP -qFx 'install -d /usr/sbin' <$<
	GREP -qFx 'install -d /usr/libexec' <$<
	GREP -qFx 'install -d /usr/share' <$<
	GREP -qFx 'install -d /usr/etc' <$<
	GREP -qFx 'install -d /usr/com' <$<
	GREP -qFx 'install -d /usr/var' <$<
	GREP -qFx 'install -d /usr/var/run' <$<
	GREP -qFx 'install -d /usr/include' <$<
	GREP -qFx 'install -d /usr/shareinfo' <$<
	GREP -qFx 'install -d /usr/lib' <$<
	GREP -qFx 'install -d /usr/share/locale' <$<
	GREP -qFx 'install -d /usr/share/man' <$<
	GREP -qFx 'install -d /usr/share/man/man1' <$<
	GREP -qFx 'install -d /usr/share/man/man2' <$<
	GREP -qFx 'install -d /usr/share/man/man3' <$<
	GREP -qFx 'install -d /usr/share/man/man4' <$<
	GREP -qFx 'install -d /usr/share/man/man5' <$<
	GREP -qFx 'install -d /usr/share/man/man6' <$<
	GREP -qFx 'install -d /usr/share/man/man7' <$<
	GREP -qFx 'install -d /usr/share/man/man8' <$<
	GREP -qFx 'install -d /usr/share/man/man9' <$<

debug-sysconfdir.log: ZMK.makeOverrides += sysconfdir=/etc
debug-sysconfdir: debug-sysconfdir.log
	GREP -qFx "install -d /etc" <$<

debug-libexecdir.log: ZMK.makeOverrides += prefix=/usr libexecdir=/usr/lib/NAME
debug-libexecdir: debug-libexecdir.log
	GREP -qFx "install -d /usr/lib/NAME" <$<
