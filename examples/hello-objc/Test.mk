# This file is a part of zmk test system.
include ../../tests/Common.mk

.PHONY: check

check:: check-build
check-build:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -c -o hello-hello.o hello.m'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -o hello hello-hello.o -lobjc'


check:: check-clean
check-clean:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f hello'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f hello-hello.o'


check:: check-install
check-install:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/bin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0755 hello /usr/local/bin/hello'


check:: check-uninstall
check-uninstall:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/bin/hello'
