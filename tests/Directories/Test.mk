#!/usr/bin/make -f
include ../Common.mk

t:: install-defaults install-name-defined install-destdir install-prefix \
	install-sysconfdir install-libexecdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directories

install-defaults: install-defaults.log
	MATCH -qF 'DEBUG: prefix=/usr/local' <$<
	MATCH -qF 'install -d /usr/local' <$<
	MATCH -qF 'install -d /usr/local/bin' <$<
	MATCH -qF 'install -d /usr/local/sbin' <$<
	MATCH -qF 'install -d /usr/local/libexec' <$<
	MATCH -qF 'install -d /usr/local/share' <$<
	MATCH -qF 'install -d /usr/local/etc' <$<
	MATCH -qF 'install -d /usr/local/com' <$<
	MATCH -qF 'install -d /usr/local/var' <$<
	MATCH -qF 'install -d /usr/local/var/run' <$<
	MATCH -qF 'install -d /usr/local/include' <$<
	MATCH -qF 'install -d /usr/local/shareinfo' <$<
	MATCH -qF 'install -d /usr/local/lib' <$<
	MATCH -qF 'install -d /usr/local/share/locale' <$<
	MATCH -qF 'install -d /usr/local/share/man' <$<
	MATCH -qF 'install -d /usr/local/share/man/man1' <$<
	MATCH -qF 'install -d /usr/local/share/man/man2' <$<
	MATCH -qF 'install -d /usr/local/share/man/man3' <$<
	MATCH -qF 'install -d /usr/local/share/man/man4' <$<
	MATCH -qF 'install -d /usr/local/share/man/man5' <$<
	MATCH -qF 'install -d /usr/local/share/man/man6' <$<
	MATCH -qF 'install -d /usr/local/share/man/man7' <$<
	MATCH -qF 'install -d /usr/local/share/man/man8' <$<
	MATCH -qF 'install -d /usr/local/share/man/man9' <$<

install-name-defined.log: ZMK.makeOverrides += NAME=test
install-name-defined: install-name-defined.log
	MATCH -qF 'install -d /usr/local/share/doc/test' <$<

install-destdir.log: ZMK.makeOverrides += DESTDIR=/foo
install-destdir: install-destdir.log
	MATCH -qF 'DEBUG: prefix=/usr/local' <$<
	MATCH -qF 'DEBUG: DESTDIR=/foo' <$<
	MATCH -qF 'install -d /foo/usr/local' <$<
	MATCH -qF 'install -d /foo/usr/local/bin' <$<
	MATCH -qF 'install -d /foo/usr/local/sbin' <$<
	MATCH -qF 'install -d /foo/usr/local/libexec' <$<
	MATCH -qF 'install -d /foo/usr/local/share' <$<
	MATCH -qF 'install -d /foo/usr/local/etc' <$<
	MATCH -qF 'install -d /foo/usr/local/com' <$<
	MATCH -qF 'install -d /foo/usr/local/var' <$<
	MATCH -qF 'install -d /foo/usr/local/var/run' <$<
	MATCH -qF 'install -d /foo/usr/local/include' <$<
	MATCH -qF 'install -d /foo/usr/local/shareinfo' <$<
	MATCH -qF 'install -d /foo/usr/local/lib' <$<
	MATCH -qF 'install -d /foo/usr/local/share/locale' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man1' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man2' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man3' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man4' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man5' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man6' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man7' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man8' <$<
	MATCH -qF 'install -d /foo/usr/local/share/man/man9' <$<

install-prefix.log: ZMK.makeOverrides += prefix=/usr
install-prefix: install-prefix.log
	MATCH -qF 'DEBUG: prefix=/usr' <$<
	MATCH -qF 'install -d /usr' <$<
	MATCH -qF 'install -d /usr/bin' <$<
	MATCH -qF 'install -d /usr/sbin' <$<
	MATCH -qF 'install -d /usr/libexec' <$<
	MATCH -qF 'install -d /usr/share' <$<
	MATCH -qF 'install -d /usr/etc' <$<
	MATCH -qF 'install -d /usr/com' <$<
	MATCH -qF 'install -d /usr/var' <$<
	MATCH -qF 'install -d /usr/var/run' <$<
	MATCH -qF 'install -d /usr/include' <$<
	MATCH -qF 'install -d /usr/shareinfo' <$<
	MATCH -qF 'install -d /usr/lib' <$<
	MATCH -qF 'install -d /usr/share/locale' <$<
	MATCH -qF 'install -d /usr/share/man' <$<
	MATCH -qF 'install -d /usr/share/man/man1' <$<
	MATCH -qF 'install -d /usr/share/man/man2' <$<
	MATCH -qF 'install -d /usr/share/man/man3' <$<
	MATCH -qF 'install -d /usr/share/man/man4' <$<
	MATCH -qF 'install -d /usr/share/man/man5' <$<
	MATCH -qF 'install -d /usr/share/man/man6' <$<
	MATCH -qF 'install -d /usr/share/man/man7' <$<
	MATCH -qF 'install -d /usr/share/man/man8' <$<
	MATCH -qF 'install -d /usr/share/man/man9' <$<

install-sysconfdir.log: ZMK.makeOverrides += sysconfdir=/etc
install-sysconfdir: install-sysconfdir.log
	MATCH -qF "install -d /etc" <$<

install-libexecdir.log: ZMK.makeOverrides += prefix=/usr libexecdir=/usr/lib/NAME
install-libexecdir: install-libexecdir.log
	MATCH -qF "install -d /usr/lib/NAME" <$<
