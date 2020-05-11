# This file is a part of zmk test system.
include ../../tests/Common.mk

.PHONY: check


check:: check-install-h
check-install-h:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/include'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0644 hello.h /usr/local/include/hello.h'

check:: check-uninstall-h
check-uninstall-h:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/include/hello.h'


check-%-a: TEST_OPTS += Toolchain.CC.ImageFormat=Irrelevant
check-%-so: TEST_OPTS += Toolchain.CC.ImageFormat=ELF
check-%-dylib: TEST_OPTS += Toolchain.CC.ImageFormat=Mach-O


check:: check-build-a
check-build-a:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -c -o libhello.a-hello.o hello.m'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'ar -cr libhello.a libhello.a-hello.o'

check:: check-clean-a
check-clean-a:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.a'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.a-hello.o'

check:: check-install-a
check-install-a:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -d /usr/local/lib'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0644 libhello.a /usr/local/lib/libhello.a'

check:: check-uninstall-a
check-uninstall-a:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/lib/libhello.a'


check:: check-build-so
check-build-so:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -fpic -c -o libhello.so.1-hello.o hello.m'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -fpic -shared -Wl,-soname=libhello.so.1 -o libhello.so.1 libhello.so.1-hello.o'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'ln -s libhello.so.1 libhello.so'

check:: check-clean-so
check-clean-so:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.so.1-hello.o'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.so.1'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.so'

check:: check-install-so
check-install-so:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0644 libhello.so.1 /usr/local/lib/libhello.so.1'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'ln -s libhello.so.1 /usr/local/lib/libhello.so'

check:: check-uninstall-so
check-uninstall-so:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/lib/libhello.so.1'
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/lib/libhello.so'


check:: check-build-dylib
check-build-dylib:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -fpic -c -o libhello.1.dylib-hello.o hello.m'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -fpic -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libhello.1.dylib libhello.1.dylib-hello.o'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'ln -s libhello.1.dylib libhello.dylib'

check:: check-clean-dylib
check-clean-dylib:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.1.dylib-hello.o'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.1.dylib'
	$(MAKE) $(TEST_OPTS) clean | MATCH -qF 'rm -f libhello.dylib'

check:: check-install-dylib
check-install-dylib:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'install -m 0644 libhello.1.dylib /usr/local/lib/libhello.1.dylib'
	$(MAKE) $(TEST_OPTS) install | MATCH -qF 'ln -s libhello.1.dylib /usr/local/lib/libhello.dylib'

check:: check-uninstall-dylib
check-uninstall-dylib:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/lib/libhello.1.dylib'
	$(MAKE) $(TEST_OPTS) uninstall | MATCH -qF 'rm -f /usr/local/lib/libhello.dylib'
