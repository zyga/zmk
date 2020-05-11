include ../Common.mk
export DEBUG = directory

.PHONY: check

check:: check-install-rule
.PHONY: check-install-rule
check-install-rule:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install DESTDIR=/tmp | MATCH -qF 'install -d /tmp/foo'
