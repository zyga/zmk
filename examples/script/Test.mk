# This file is a part of zmk test system.
include ../../tests/Common.mk

.PHONY: check


check:: check-build
check-build:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF ''


check:: check-clean
check-clean:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF ''


check:: check-install
check-install:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/bin'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0755 hello.sh /usr/local/bin/hello.sh'


check:: check-uninstall
check-uninstall:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/bin/hello.sh'


check:: check-check-with-shellcheck
check-check-with-shellcheck: TEST_OPTS += ZMK.shellcheck=shellcheck
check-check-with-shellcheck:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) check | MATCH -qF 'shellcheck hello.sh'

check:: check-check-no-shellcheck
check-check-no-shellcheck: TEST_OPTS += ZMK.shellcheck=
check-check-no-shellcheck:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) check | MATCH -qF 'echo "ZMK: install shellcheck to analyze hello.sh"' 
