#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean

$(eval $(ZMK.isolateHostToolchain))

# Test has three variants, for Linux, MacOS and the rest.
%-other.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=Irrelevant
%-linux.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=ELF
%-macos.log: ZMK.makeOverrides += Toolchain.CC.ImageFormat=Mach-O

all: all-other all-linux all-macos
install: install-other install-linux install-macos
uninstall: uninstall-other uninstall-linux uninstall-macos
clean: clean-other clean-linux clean-macos

all-other: all-other.log
	GREP -qFx 'cc -MMD -c -o libhello.a-hello.o $(if $(VPATH),$(VPATH)/)hello.c' <$<
	GREP -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
install-other: install-other.log
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(if $(VPATH),$(VPATH)/)hello.h /usr/local/include/hello.h' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
uninstall-other: uninstall-other.log
	GREP -qFx 'rm -f /usr/local/include/hello.h' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.a' <$<
clean-other: clean-other.log
	GREP -qFx 'rm -f libhello.a' <$<
	GREP -qFx 'rm -f libhello.a-hello.o' <$<

all-linux: all-linux.log
	GREP -qFx 'cc -MMD -c -o libhello.a-hello.o $(if $(VPATH),$(VPATH)/)hello.c' <$<
	GREP -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
	GREP -qFx 'cc -fpic -MMD -c -o libhello.so.1-hello.o $(if $(VPATH),$(VPATH)/)hello.c' <$<
	GREP -qFx 'cc -shared -Wl,-soname=libhello.so.1 -o libhello.so.1 libhello.so.1-hello.o' <$<
	GREP -qFx 'ln -s libhello.so.1 libhello.so' <$<
install-linux: install-linux.log
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(if $(VPATH),$(VPATH)/)hello.h /usr/local/include/hello.h' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	GREP -qFx 'install -m 0644 libhello.so.1 /usr/local/lib/libhello.so.1' <$<
	GREP -qFx 'ln -s libhello.so.1 /usr/local/lib/libhello.so' <$<
uninstall-linux: uninstall-linux.log
	GREP -qFx 'rm -f /usr/local/include/hello.h' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.a' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.so.1' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.so' <$<
clean-linux: clean-linux.log
	GREP -qFx 'rm -f libhello.a' <$<
	GREP -qFx 'rm -f libhello.a-hello.o' <$<
	GREP -qFx 'rm -f libhello.so.1-hello.o' <$<
	GREP -qFx 'rm -f libhello.so.1' <$<
	GREP -qFx 'rm -f libhello.so' <$<

all-macos: all-macos.log
	GREP -qFx 'cc -MMD -c -o libhello.a-hello.o $(if $(VPATH),$(VPATH)/)hello.c' <$<
	GREP -qFx 'ar -cr libhello.a libhello.a-hello.o' <$<
	GREP -qFx 'cc -fpic -MMD -c -o libhello.1.dylib-hello.o $(if $(VPATH),$(VPATH)/)hello.c' <$<
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libhello.1.dylib libhello.1.dylib-hello.o' <$<
	GREP -qFx 'ln -s libhello.1.dylib libhello.dylib' <$<
install-macos: install-macos.log
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(if $(VPATH),$(VPATH)/)hello.h /usr/local/include/hello.h' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libhello.a /usr/local/lib/libhello.a' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libhello.1.dylib /usr/local/lib/libhello.1.dylib' <$<
	GREP -qFx 'ln -s libhello.1.dylib /usr/local/lib/libhello.dylib' <$<
uninstall-macos: uninstall-macos.log
	GREP -qFx 'rm -f /usr/local/include/hello.h' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.a' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.1.dylib' <$<
	GREP -qFx 'rm -f /usr/local/lib/libhello.dylib' <$<
clean-macos: clean-macos.log
	GREP -qFx 'rm -f libhello.a' <$<
	GREP -qFx 'rm -f libhello.a-hello.o' <$<
	GREP -qFx 'rm -f libhello.1.dylib-hello.o' <$<
	GREP -qFx 'rm -f libhello.1.dylib' <$<
	GREP -qFx 'rm -f libhello.dylib' <$<
