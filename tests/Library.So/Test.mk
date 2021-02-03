#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-destdir install-destdir uninstall-destdir clean-destdir \
    all-enable-dynamic-libs all-disable-dynamic-libs

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.so
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Some logs behave as if configure --enable-dynamic was used
%-enable-dynamic-libs.log: ZMK.makeOverrides += Configure.DynamicLibraries=yes
# Some logs behave as if configure --disable-dynamic was used
%-disable-dynamic-libs.log: ZMK.makeOverrides += Configure.DynamicLibraries=
# Test depends on source files
%.log: foo.c

all: all.log
	# Building a shared library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.so.1-foo.d) -c -o libfoo.so.1-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libbar.so-bar.d) -c -o libbar.so-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.c' <$<
	# Links objects together
	GREP -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
	GREP -qFx 'cc -shared -Wl,-soname=libbar.so -o libbar.so libbar.so-bar.o' <$<
	# And provides the .so alias, when the library is versioned
	GREP -qFx 'ln -sf libfoo.so.1 libfoo.so' <$<
	GREP -v -qFx 'ln -sf libbar.so libbar' <$<
install: install.log
	# Installing shared libraries creates parent directories.
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	# Installing shared libraries copies the shared library.
	GREP -qFx 'install -m 0644 libfoo.so.1 /usr/local/lib/libfoo.so.1' <$<
	GREP -qFx 'install -m 0644 libbar.so /usr/local/lib/libbar.so' <$<
	# Installing shared libraries creates the alias, when the library is versioned.
	GREP -qFx 'ln -sf libfoo.so.1 /usr/local/lib/libfoo.so' <$<
	GREP -v -qFx 'ln -sf libbar.so /usr/local/lib/libbar' <$<
uninstall: uninstall.log
	# Uninstalling shared libraries removes the shared library.
	GREP -qFx 'rm -f /usr/local/lib/libfoo.so.1' <$<
	GREP -qFx 'rm -f /usr/local/lib/libbar.so' <$<
	# If the library is versioned, the alias is removed as well.>>
	GREP -qFx 'rm -f /usr/local/lib/libfoo.so' <$<
	# Libraries without versions do not emit incorrect bare filename.
	GREP -v -qFx 'rm -f /usr/local/lib/libbar' <$<
clean: clean.log
	# Cleaning shared libraries removes the shared library and the alias.>
	GREP -qFx 'rm -f libfoo.so.1' <$<
	GREP -qFx 'rm -f libfoo.so' <$<
	GREP -qFx 'rm -f libbar.so' <$<
	# Cleaning shared libraries removes the object files and dependency files.
	GREP -v -qFx 'rm -f /usr/local/lib/libbar' <$<
	GREP -qFx 'rm -f ./libfoo.so.1-foo.o' <$<
	GREP -qFx 'rm -f ./libbar.so-bar.o' <$<
	GREP -qFx 'rm -f ./libbar.so-bar.d' <$<

all-destdir: all-destdir.log
	# Building a shared library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.so.1-foo.d) -c -o libfoo.so.1-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libbar.so-bar.d) -c -o libbar.so-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.c' <$<
	# Links objects together
	GREP -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
	GREP -qFx 'cc -shared -Wl,-soname=libbar.so -o libbar.so libbar.so-bar.o' <$<
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
	GREP -qFx 'rm -f /destdir/usr/local/lib/libbar.so' <$<
	GREP -v -qFx 'rm -f /usr/local/lib/libbar' <$<
clean-destdir: clean-destdir.log
	# Cleaning shared libraries removes the shared library and the alias.
	GREP -qFx 'rm -f libfoo.so.1' <$<
	GREP -qFx 'rm -f libfoo.so' <$<
	GREP -qFx 'rm -f libbar.so' <$<
	# Cleaning shared libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.so.1-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.so.1-foo.d' <$<
	GREP -qFx 'rm -f ./libbar.so-bar.o' <$<
	GREP -qFx 'rm -f ./libbar.so-bar.d' <$<

all-enable-dynamic-libs: all-enable-dynamic-libs.log
	# Configuring --enable-dynamic enables compilation of dynamic libraries.
	GREP -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
all-disable-dynamic-libs: all-disable-dynamic-libs.log
	# Configuring --disable-dynamic disables compilation of dynamic libraries.
	GREP -v -qFx 'cc -shared -Wl,-soname=libfoo.so.1 -o libfoo.so.1 libfoo.so.1-foo.o' <$<
