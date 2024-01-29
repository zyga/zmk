#!/usr/bin/make -f
# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-sysroot \
    all-destdir install-destdir uninstall-destdir clean-destdir \
    all-enable-dynamic-libs all-disable-dynamic-libs

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.dylib
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Some logs behave as if configure --enable-dynamic was used
%-enable-dynamic-libs.log: ZMK.makeOverrides += Configure.DynamicLibraries=yes
# Some logs behave as if configure --disable-dynamic was used
%-disable-dynamic-libs.log: ZMK.makeOverrides += Configure.DynamicLibraries=
# Some logs behave as if a sysroot was requested.
%-sysroot.log: ZMK.makeOverrides += Toolchain.SysRoot=/path
# Test depends on source files
%.log: foo.c

all: all.log
	# Building a dynamic library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.1.dylib-foo.d) -c -o libfoo.1.dylib-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libbar.dylib-bar.d) -c -o libbar.dylib-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.c' <$<
	# Links objects together
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libbar.dylib libbar.dylib-bar.o' <$<
	# And provides the .dylib alias, when the library is versioned
	GREP -qFx 'ln -sf libfoo.1.dylib libfoo.dylib' <$<
	GREP -v -qFx 'ln -sf libbar.dylib libbar' <$<
install: install.log
	# Installing dynamic libraries creates parent directories.
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/lib' <$<
	# Installing dynamic libraries copies the dynamic library.
	GREP -qFx 'install -m 0644 libfoo.1.dylib /usr/local/lib/libfoo.1.dylib' <$<
	GREP -qFx 'install -m 0644 libbar.dylib /usr/local/lib/libbar.dylib' <$<
	# Installing dynamic libraries creates the alias, when the library is versioned.
	GREP -qFx 'ln -sf libfoo.1.dylib /usr/local/lib/libfoo.dylib' <$<
	GREP -v -qFx 'ln -sf libbar.dylib /usr/local/lib/libbar' <$<
uninstall: uninstall.log
	# Uninstalling dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f /usr/local/lib/libfoo.1.dylib' <$<
	GREP -qFx 'rm -f /usr/local/lib/libfoo.dylib' <$<
	# If the library is versioned, the alias is removed as well.>>
	GREP -qFx 'rm -f /usr/local/lib/libbar.dylib' <$<
	# Libraries without versions do not emit incorrect bare filename.
	GREP -v -qFx 'rm -f /usr/local/lib/libbar' <$<
clean: clean.log
	# Cleaning dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f libfoo.1.dylib' <$<
	GREP -qFx 'rm -f libfoo.dylib' <$<
	GREP -qFx 'rm -f libbar.dylib' <$<
	# Cleaning dynamic libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.d' <$<
	GREP -qFx 'rm -f ./libbar.dylib-bar.o' <$<
	GREP -qFx 'rm -f ./libbar.dylib-bar.d' <$<

all-sysroot: all-sysroot.log
	# Building a dynamic library compiles object against the configured sysroot
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.1.dylib-foo.d) -c --sysroot=/path -o libfoo.1.dylib-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libbar.dylib-bar.d) -c --sysroot=/path -o libbar.dylib-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.c' <$<
	# Links objects together with the configured sysroot in scope.
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 --sysroot=/path -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 --sysroot=/path -o libbar.dylib libbar.dylib-bar.o' <$<

all-destdir: all-destdir.log
	# Building a dynamic library compiles objects
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libfoo.1.dylib-foo.d) -c -o libfoo.1.dylib-foo.o $(ZMK.test.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'cc -fpic -MMD$(if $(ZMK.test.IsOutOfTreeBuild), -MF libbar.dylib-bar.d) -c -o libbar.dylib-bar.o $(ZMK.test.OutOfTreeSourcePath)bar.c' <$<
	# Links objects together
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libbar.dylib libbar.dylib-bar.o' <$<
	# And provides the .dylib alias
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
	GREP -qFx 'rm -f /destdir/usr/local/lib/libbar.dylib' <$<
	GREP -v -qFx 'rm -f /usr/local/lib/libbar' <$<
clean-destdir: clean-destdir.log
	# Cleaning dynamic libraries removes the dynamic library and the alias.
	GREP -qFx 'rm -f libfoo.1.dylib' <$<
	GREP -qFx 'rm -f libfoo.dylib' <$<
	GREP -qFx 'rm -f libbar.dylib' <$<
	# Cleaning dynamic libraries removes the object files and dependency files.
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.o' <$<
	GREP -qFx 'rm -f ./libfoo.1.dylib-foo.d' <$<
	GREP -qFx 'rm -f ./libbar.dylib-bar.o' <$<
	GREP -qFx 'rm -f ./libbar.dylib-bar.d' <$<

all-enable-dynamic-libs: all-enable-dynamic-libs.log
	# Configuring --enable-dynamic enables compilation of dynamic libraries.
	GREP -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
all-disable-dynamic-libs: all-disable-dynamic-libs.log
	# Configuring --disable-dynamic disables compilation of dynamic libraries.
	GREP -v -qFx 'cc -dynamiclib -compatibility_version 1.0 -current_version 1.0 -o libfoo.1.dylib libfoo.1.dylib-foo.o' <$<
