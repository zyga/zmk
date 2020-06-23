#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

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
	MATCH -qFx 'cc -MMD -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
install-other: install-other.log
	MATCH -qFx 'install -d /usr/local/include' <$<
	MATCH -qFx 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qFx 'install -d /usr/local/lib' <$<
	MATCH -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
uninstall-other: uninstall-other.log
	MATCH -qFx 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.a' <$<
clean-other: clean-other.log
	MATCH -qFx 'rm -f libhello.a' <$<
	MATCH -qFx 'rm -f libhello.a-hello.o' <$<

all-linux: all-linux.log
	MATCH -qFx 'cc -MMD -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
	MATCH -qFx 'cc -fpic -MMD -c -o libhello.so.1-hello.o hello.m' <$<
	MATCH -qFx 'cc -fpic -MMD -shared -Wl,-soname=libhello.so.1 -o libhello.so.1 libhello.so.1-hello.o' <$<
	MATCH -qFx 'ln -s libhello.so.1 libhello.so' <$<
install-linux: install-linux.log
	MATCH -qFx 'install -d /usr/local/include' <$<
	MATCH -qFx 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qFx 'install -d /usr/local/lib' <$<
	MATCH -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	MATCH -qFx 'install -m 0644 libhello.so.1 /usr/local/lib/libhello.so.1' <$<
	MATCH -qFx 'ln -s libhello.so.1 /usr/local/lib/libhello.so' <$<
uninstall-linux: uninstall-linux.log
	MATCH -qFx 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.a' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.so.1' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.so' <$<
clean-linux: clean-linux.log
	MATCH -qFx 'rm -f libhello.a' <$<
	MATCH -qFx 'rm -f libhello.a-hello.o' <$<
	MATCH -qFx 'rm -f libhello.so.1-hello.o' <$<
	MATCH -qFx 'rm -f libhello.so.1' <$<
	MATCH -qFx 'rm -f libhello.so' <$<

all-macos: all-macos.log
	MATCH -qFx 'cc -MMD -c -o libhello.a-hello.o hello.m' <$<
	MATCH -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
	MATCH -qFx 'cc -fpic -MMD -c -o libhello.1.dylib-hello.o hello.m' <$<
	MATCH -qFx 'cc -fpic -MMD -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libhello.1.dylib libhello.1.dylib-hello.o' <$<
	MATCH -qFx 'ln -s libhello.1.dylib libhello.dylib' <$<
install-macos: install-macos.log
	MATCH -qFx 'install -d /usr/local/include' <$<
	MATCH -qFx 'install -m 0644 hello.h /usr/local/include/hello.h' <$<
	MATCH -qFx 'install -d /usr/local/lib' <$<
	MATCH -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	MATCH -qFx 'install -d /usr/local/lib' <$<
	MATCH -qFx 'install -m 0644 libhello.1.dylib /usr/local/lib/libhello.1.dylib' <$<
	MATCH -qFx 'ln -s libhello.1.dylib /usr/local/lib/libhello.dylib' <$<
uninstall-macos: uninstall-macos.log
	MATCH -qFx 'rm -f /usr/local/include/hello.h' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.a' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.1.dylib' <$<
	MATCH -qFx 'rm -f /usr/local/lib/libhello.dylib' <$<
clean-macos: clean-macos.log
	MATCH -qFx 'rm -f libhello.a' <$<
	MATCH -qFx 'rm -f libhello.a-hello.o' <$<
	MATCH -qFx 'rm -f libhello.1.dylib-hello.o' <$<
	MATCH -qFx 'rm -f libhello.1.dylib' <$<
	MATCH -qFx 'rm -f libhello.dylib' <$<
