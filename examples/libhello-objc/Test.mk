# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

# Test has three variants, for Linux, MacOS and the rest.
%-other.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=Irrelevant
%-linux.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=ELF
%-macos.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=Mach-O

all: all-other all-linux all-macos
install: install-other install-linux install-macos
uninstall: uninstall-other uninstall-linux uninstall-macos
clean: clean-other clean-linux clean-macos

all-other: all-other.log
	MATCH -qF 'cc -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qF 'ar -cr libhello.a libhello.a-hello.o' <$<
	test `wc -l <$<` -eq 2
install-other: install-other.log
	MATCH -qF 'install -d /usr/local/include' <$<
	MATCH -qF 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qF 'install -d /usr/local/lib' <$<
	MATCH -qF 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	test `wc -l <$<` -eq `expr 4 + 2`
uninstall-other: uninstall-other.log
	MATCH -qF 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.a' <$<
	test `wc -l <$<` -eq 2
clean-other: clean-other.log
	MATCH -qF 'rm -f libhello.a' <$<
	MATCH -qF 'rm -f libhello.a-hello.o' <$<
	test `wc -l <$<` -eq 2

all-linux: all-linux.log
	MATCH -qF 'cc -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qF 'ar -cr libhello.a libhello.a-hello.o' <$<
	MATCH -qF 'cc -fpic -c -o libhello.so.1-hello.o hello.m' <$<
	MATCH -qF 'cc -fpic -shared -Wl,-soname=libhello.so.1 -o libhello.so.1 libhello.so.1-hello.o' <$<
	MATCH -qF 'ln -s libhello.so.1 libhello.so' <$<
	test `wc -l <$<` -eq 5
install-linux: install-linux.log
	MATCH -qF 'install -d /usr/local/include' <$<
	MATCH -qF 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qF 'install -d /usr/local/lib' <$<
	MATCH -qF 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	MATCH -qF 'install -m 0644 libhello.so.1 /usr/local/lib/libhello.so.1' <$<
	MATCH -qF 'ln -s libhello.so.1 /usr/local/lib/libhello.so' <$<
	# 5 for the regular build -1 for local symlink *not* built here, 6 for install
	test `wc -l <$<` -eq `expr 5 - 1 + 6`
uninstall-linux: uninstall-linux.log
	MATCH -qF 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.a' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.so.1' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.so' <$<
	test `wc -l <$<` -eq 4
clean-linux: clean-linux.log
	MATCH -qF 'rm -f libhello.a' <$<
	MATCH -qF 'rm -f libhello.a-hello.o' <$<
	MATCH -qF 'rm -f libhello.so.1-hello.o' <$<
	MATCH -qF 'rm -f libhello.so.1' <$<
	MATCH -qF 'rm -f libhello.so' <$<
	test `wc -l <$<` -eq 5

all-macos: all-macos.log
	MATCH -qF 'cc -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qF 'ar -cr libhello.a libhello.a-hello.o' <$<
	MATCH -qF 'cc -fpic -c -o libhello.1.dylib-hello.o hello.m' <$<
	MATCH -qF 'cc -fpic -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libhello.1.dylib libhello.1.dylib-hello.o' <$<
	MATCH -qF 'ln -s libhello.1.dylib libhello.dylib' <$<
	test `wc -l <$<` -eq 5
install-macos: install-macos.log
	MATCH -qF 'install -d /usr/local/include' <$<
	MATCH -qF 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qF 'install -d /usr/local/lib' <$<
	MATCH -qF 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	MATCH -qF 'install -d /usr/local/lib' <$<
	MATCH -qF 'install -m 0644 libhello.1.dylib /usr/local/lib/libhello.1.dylib' <$<
	MATCH -qF 'ln -s libhello.1.dylib /usr/local/lib/libhello.dylib' <$<
	# 5 for the regular build -1 for local symlink *not* built here, 6 for install
	test `wc -l <$<` -eq `expr 5 - 1 + 6`
uninstall-macos: uninstall-macos.log
	MATCH -qF 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.a' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.1.dylib' <$<
	MATCH -qF 'rm -f /usr/local/lib/libhello.dylib' <$<
	test `wc -l <$<` -eq 4
clean-macos: clean-macos.log
	MATCH -qF 'rm -f libhello.a' <$<
	MATCH -qF 'rm -f libhello.a-hello.o' <$<
	MATCH -qF 'rm -f libhello.1.dylib-hello.o' <$<
	MATCH -qF 'rm -f libhello.1.dylib' <$<
	MATCH -qF 'rm -f libhello.dylib' <$<
	test `wc -l <$<` -eq 5
