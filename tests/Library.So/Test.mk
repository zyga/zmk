#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-destdir install-destdir uninstall-destdir clean-destdir

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.so
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.c

all: all.log
	# Building a shared library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.so.1-foo.d) -c -o libfoo.so.1-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Links objects together
	GREP -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
	# And provides the .so alias
	GREP -qFx 'ln -sf libfoo.so.1 libfoo.so' <$<
install: install.log
	# Installing shared libraries creates parent directories.
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	# Installing shared libraries copies the shared library.
	GREP -qFx 'install -m 0644 libfoo.so.1 /usr/local/lib/libfoo.so.1' <$<
	# Installing shared libraries creates the alias.
	GREP -qFx 'ln -sf libfoo.so.1 /usr/local/lib/libfoo.so' <$<
uninstall: uninstall.log
	# Uninstalling shared libraries removes the shared library and the alias.
	GREP -qFx 'rm -f /usr/local/lib/libfoo.so.1' <$<
	GREP -qFx 'rm -f /usr/local/lib/libfoo.so' <$<
clean: clean.log
	# Cleaning shared libraries removes the shared library and the alias.
	GREP -qFx 'rm -f libfoo.so.1' <$<
	GREP -qFx 'rm -f libfoo.so' <$<
	# Cleaning shared libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.so.1-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.so.1-foo.d' <$<

all-destdir: all-destdir.log
	# Building a shared library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.so.1-foo.d) -c -o libfoo.so.1-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	# Links objects together
	GREP -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
	# And provides the .so alias
	GREP -qFx 'ln -sf libfoo.so.1 libfoo.so' <$<
install-destdir: install-destdir.log
	# Installing shared libraries creates parent directories.
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr' <$<
	GREP -qFx 'install -d /destdir/usr/local' <$<
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	# Installing shared libraries copies the shared library.
	GREP -qFx 'install -m 0644 libfoo.so.1 /destdir/usr/local/lib/libfoo.so.1' <$<
	# Installing shared libraries creates the alias.
	GREP -qFx 'ln -sf libfoo.so.1 /destdir/usr/local/lib/libfoo.so' <$<
uninstall-destdir: uninstall-destdir.log
	# Uninstalling shared libraries removes the shared library and the alias.
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.so.1' <$<
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.so' <$<
clean-destdir: clean-destdir.log
	# Cleaning shared libraries removes the shared library and the alias.
	GREP -qFx 'rm -f libfoo.so.1' <$<
	GREP -qFx 'rm -f libfoo.so' <$<
	# Cleaning shared libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.so.1-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.so.1-foo.d' <$<
