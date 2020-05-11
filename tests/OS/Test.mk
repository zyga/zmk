include ../Common.mk
export DEBUG = os

.PHONY: check

check:: check-linux
.PHONY: check-linux
check-linux: TEST_OPTS += OS.Kernel=Linux
check-linux:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=Linux'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'

check:: check-freebsd
.PHONY: check-freebsd
check-freebsd: TEST_OPTS += OS.Kernel=FreeBSD
check-freebsd:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=FreeBSD'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'

check:: check-openbsd
.PHONY: check-openbsd
check-openbsd: TEST_OPTS += OS.Kernel=OpenBSD
check-openbsd:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=OpenBSD'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'

check:: check-netbsd
.PHONY: check-netbsd
check-netbsd: TEST_OPTS += OS.Kernel=NetBSD
check-netbsd:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=NetBSD'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'

check:: check-hurd
.PHONY: check-hurd
check-hurd: TEST_OPTS += OS.Kernel=GNU
check-hurd:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=GNU'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'


check:: check-gnu-kfreebsd
.PHONY: check-gnu-kfreebsd
check-gnu-kfreebsd: TEST_OPTS += OS.Kernel=GNU/kFreeBSD
check-gnu-kfreebsd:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=GNU/kFreeBSD'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'


check:: check-solaris
.PHONY: check-solaris
check-solaris: TEST_OPTS += OS.Kernel=SunOS
check-solaris:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=SunOS'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'


check:: check-darwin
.PHONY: check-darwin
check-darwin: TEST_OPTS += OS.Kernel=Darwin
check-darwin:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=Darwin'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=Mach-O'


check:: check-windows
.PHONY: check-windows
check-windows: export OS=Windows_NT
check-windows:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=Windows_NT'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=PE'


check:: check-haiku
.PHONY: check-haiku
check-haiku: TEST_OPTS += OS.Kernel=Haiku
check-haiku:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.Kernel=Haiku'
	$(MAKE) $(TEST_OPTS) | MATCH -qF 'DEBUG: OS.ImageFormat=ELF'


check:: check-unknown
.PHONY: check-unknown
check-unknown: TEST_OPTS += OS.Kernel=Unknown
check-unknown:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) 2>&1 | MATCH -Eq '[*]{3} unsupported operating system kernel Unknown\.'
