# This file is a part of zmk test system.
include ../../tests/Common.mk

.PHONY: check

# MacOS uses c++, GNU uses g++ by default
check-build: TEST_OPTS += CXX=c++

check:: check-build
check-build:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'c++ -c -o hello-hello.o hello.cpp'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'c++ -o hello hello-hello.o'


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
