include ../Common.mk
export DEBUG = directories

.PHONY: check

check:: check-destdir
.PHONY: check-destdir
check-destdir: TEST_OPTS += DESTDIR=/foo
check-destdir:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: DESTDIR=/foo'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/bin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/sbin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/libexec'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/etc'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/com'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/var'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/var/run'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/include'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/doc/test'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/shareinfo'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/lib'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/locale'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man1'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man2'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man3'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man4'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man5'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man6'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man7'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man8'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /foo/usr/local/share/man/man9'

# those are the defaults
check:: check-defaults
.PHONY: check-defaults
check-defaults:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: prefix=/usr/local'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/bin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/sbin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/libexec'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/etc'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/com'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/var'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/var/run'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/include'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/doc/test'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/shareinfo'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/lib'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/locale'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man1'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man2'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man3'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man4'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man5'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man6'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man7'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man8'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/share/man/man9'

# prefix is respected
check:: check-prefix
.PHONY: check-prefix
check-prefix: TEST_OPTS += prefix=/usr
check-prefix:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: prefix=/usr'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/bin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/sbin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/libexec'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/etc'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/com'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/var'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/var/run'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/include'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/doc/test'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/shareinfo'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/lib'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/locale'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man1'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man2'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man3'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man4'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man5'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man6'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man7'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man8'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/share/man/man9'

# sysconfdir can be customized
check:: check-sysconfdir
.PHONY: check-sysconfdir
check-sysconfdir: TEST_OPTS += prefix=/usr sysconfdir=/etc
check-sysconfdir:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF "install -d /etc"

# libexecdir can be customized
check:: check-libexecdir
.PHONY: check-libexecdir
check-libexecdir: TEST_OPTS += prefix=/usr libexecdir=/usr/lib/NAME
check-libexecdir:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF "install -d /usr/lib/NAME"
