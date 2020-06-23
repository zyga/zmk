#!/usr/bin/make -f
include zmk/internalTest.mk

t:: install-defaults install-name-defined install-destdir install-prefix \
	install-sysconfdir install-libexecdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directories

install-defaults: install-defaults.log
	GREP -qF 'DEBUG: prefix=/usr/local' <$<
	GREP -qF 'install -d /usr/local' <$<
	GREP -qF 'install -d /usr/local/bin' <$<
	GREP -qF 'install -d /usr/local/sbin' <$<
	GREP -qF 'install -d /usr/local/libexec' <$<
	GREP -qF 'install -d /usr/local/share' <$<
	GREP -qF 'install -d /usr/local/etc' <$<
	GREP -qF 'install -d /usr/local/com' <$<
	GREP -qF 'install -d /usr/local/var' <$<
	GREP -qF 'install -d /usr/local/var/run' <$<
	GREP -qF 'install -d /usr/local/include' <$<
	GREP -qF 'install -d /usr/local/shareinfo' <$<
	GREP -qF 'install -d /usr/local/lib' <$<
	GREP -qF 'install -d /usr/local/share/locale' <$<
	GREP -qF 'install -d /usr/local/share/man' <$<
	GREP -qF 'install -d /usr/local/share/man/man1' <$<
	GREP -qF 'install -d /usr/local/share/man/man2' <$<
	GREP -qF 'install -d /usr/local/share/man/man3' <$<
	GREP -qF 'install -d /usr/local/share/man/man4' <$<
	GREP -qF 'install -d /usr/local/share/man/man5' <$<
	GREP -qF 'install -d /usr/local/share/man/man6' <$<
	GREP -qF 'install -d /usr/local/share/man/man7' <$<
	GREP -qF 'install -d /usr/local/share/man/man8' <$<
	GREP -qF 'install -d /usr/local/share/man/man9' <$<

install-name-defined.log: ZMK.makeOverrides += NAME=test
install-name-defined: install-name-defined.log
	GREP -qF 'install -d /usr/local/share/doc/test' <$<

install-destdir.log: ZMK.makeOverrides += DESTDIR=/foo
install-destdir: install-destdir.log
	GREP -qF 'DEBUG: prefix=/usr/local' <$<
	GREP -qF 'DEBUG: DESTDIR=/foo' <$<
	GREP -qF 'install -d /foo/usr/local' <$<
	GREP -qF 'install -d /foo/usr/local/bin' <$<
	GREP -qF 'install -d /foo/usr/local/sbin' <$<
	GREP -qF 'install -d /foo/usr/local/libexec' <$<
	GREP -qF 'install -d /foo/usr/local/share' <$<
	GREP -qF 'install -d /foo/usr/local/etc' <$<
	GREP -qF 'install -d /foo/usr/local/com' <$<
	GREP -qF 'install -d /foo/usr/local/var' <$<
	GREP -qF 'install -d /foo/usr/local/var/run' <$<
	GREP -qF 'install -d /foo/usr/local/include' <$<
	GREP -qF 'install -d /foo/usr/local/shareinfo' <$<
	GREP -qF 'install -d /foo/usr/local/lib' <$<
	GREP -qF 'install -d /foo/usr/local/share/locale' <$<
	GREP -qF 'install -d /foo/usr/local/share/man' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man1' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man2' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man3' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man4' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man5' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man6' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man7' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man8' <$<
	GREP -qF 'install -d /foo/usr/local/share/man/man9' <$<

install-prefix.log: ZMK.makeOverrides += prefix=/usr
install-prefix: install-prefix.log
	GREP -qF 'DEBUG: prefix=/usr' <$<
	GREP -qF 'install -d /usr' <$<
	GREP -qF 'install -d /usr/bin' <$<
	GREP -qF 'install -d /usr/sbin' <$<
	GREP -qF 'install -d /usr/libexec' <$<
	GREP -qF 'install -d /usr/share' <$<
	GREP -qF 'install -d /usr/etc' <$<
	GREP -qF 'install -d /usr/com' <$<
	GREP -qF 'install -d /usr/var' <$<
	GREP -qF 'install -d /usr/var/run' <$<
	GREP -qF 'install -d /usr/include' <$<
	GREP -qF 'install -d /usr/shareinfo' <$<
	GREP -qF 'install -d /usr/lib' <$<
	GREP -qF 'install -d /usr/share/locale' <$<
	GREP -qF 'install -d /usr/share/man' <$<
	GREP -qF 'install -d /usr/share/man/man1' <$<
	GREP -qF 'install -d /usr/share/man/man2' <$<
	GREP -qF 'install -d /usr/share/man/man3' <$<
	GREP -qF 'install -d /usr/share/man/man4' <$<
	GREP -qF 'install -d /usr/share/man/man5' <$<
	GREP -qF 'install -d /usr/share/man/man6' <$<
	GREP -qF 'install -d /usr/share/man/man7' <$<
	GREP -qF 'install -d /usr/share/man/man8' <$<
	GREP -qF 'install -d /usr/share/man/man9' <$<

install-sysconfdir.log: ZMK.makeOverrides += sysconfdir=/etc
install-sysconfdir: install-sysconfdir.log
	GREP -qF "install -d /etc" <$<

install-libexecdir.log: ZMK.makeOverrides += prefix=/usr libexecdir=/usr/lib/NAME
install-libexecdir: install-libexecdir.log
	GREP -qF "install -d /usr/lib/NAME" <$<
