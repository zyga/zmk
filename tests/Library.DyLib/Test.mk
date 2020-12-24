#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-destdir install-destdir uninstall-destdir clean-destdir

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.dylib
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.c

all: all.log
	# Building a dynamic library compiles objects
	GREP -qFx 'cc -fpic -MMD -c -o libfoo.1.dylib-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Links objects together
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
	# And provides the .so alias
	GREP -qFx 'ln -sf libfoo.1.dylib libfoo.dylib' <$<
install: install.log
	# Installing dynamic libraries creates parent directories.
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	# Installing dynamic libraries copies the dynamic library.
	GREP -qFx 'install -m 0644 libfoo.1.dylib /usr/local/lib/libfoo.1.dylib' <$<
	# Installing dynamic libraries creates the alias.
	GREP -qFx 'ln -sf libfoo.1.dylib /usr/local/lib/libfoo.dylib' <$<
uninstall: uninstall.log
	# Uninstalling dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f /usr/local/lib/libfoo.1.dylib' <$<
	GREP -qFx 'rm -f /usr/local/lib/libfoo.dylib' <$<
clean: clean.log
	# Cleaning dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f libfoo.1.dylib' <$<
	GREP -qFx 'rm -f libfoo.dylib' <$<
	# Cleaning dynamic libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.d' <$<

all-destdir: all-destdir.log
	# Building a dynamic library compiles objects
	GREP -qFx 'cc -fpic -MMD -c -o libfoo.1.dylib-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Links objects together
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
	# And provides the .so alias
	GREP -qFx 'ln -sf libfoo.1.dylib libfoo.dylib' <$<
install-destdir: install-destdir.log
	# Installing dynamic libraries creates parent directories.
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr' <$<
	GREP -qFx 'install -d /destdir/usr/local' <$<
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	# Installing dynamic libraries copies the dynamic library.
	GREP -qFx 'install -m 0644 libfoo.1.dylib /destdir/usr/local/lib/libfoo.1.dylib' <$<
	# Installing dynamic libraries creates the alias.
	GREP -qFx 'ln -sf libfoo.1.dylib /destdir/usr/local/lib/libfoo.dylib' <$<
uninstall-destdir: uninstall-destdir.log
	# Uninstalling dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.1.dylib' <$<
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.dylib' <$<
clean-destdir: clean-destdir.log
	# Cleaning dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f libfoo.1.dylib' <$<
	GREP -qFx 'rm -f libfoo.dylib' <$<
	# Cleaning dynamic libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.d' <$<
