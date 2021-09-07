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

include zmk/internalTest.mk

t:: all clean install uninstall \
    all-destdir clean-destdir install-destdir uninstall-destdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=symlink
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir

all: all.log
	# Building a symlink just creates it.
	GREP -qFx 'ln -sf target name1' <$<
	GREP -qFx 'ln -sf target name2' <$<
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'ln -sf ../target subdir/name3' <$<
	GREP -qFx 'ln -sf ../target subdir/name4' <$<
clean: clean.log
	# Cleaning a symlink removes it.
	GREP -qFx 'rm -f name1' <$<
	GREP -qFx 'rm -f name2' <$<
	GREP -qFx 'rm -f subdir/name3' <$<
	GREP -qFx 'rm -f subdir/name4' <$<
install: install.log
	# Installing a symlink creates the install directory
	# and then places the symlink there.
	GREP -qFx 'install -d /some' <$<
	GREP -qFx 'install -d /some/path' <$<
	GREP -qFx 'ln -sf target /some/path/name1' <$<
	GREP -qFx 'ln -sf target /other/path/custom-install-name2' <$<
	GREP -qFx 'install -d /other' <$<
	GREP -qFx 'install -d /other/path' <$<
	GREP -qFx 'ln -sf ../target /other/path/name3' <$<
	GREP -qFx 'ln -sf ../target /other/path/custom-install-name4' <$<
uninstall: uninstall.log
	# Uninstalling a symlink removes it.
	GREP -qFx 'rm -f /some/path/name1' <$<
	GREP -qFx 'rm -f /other/path/custom-install-name2' <$<
	GREP -qFx 'rm -f /other/path/name3' <$<
	GREP -qFx 'rm -f /other/path/custom-install-name4' <$<


all-destdir: all-destdir.log
	# Building a symlink just creates it.
	GREP -qFx 'ln -sf target name1' <$<
	GREP -qFx 'ln -sf target name2' <$<
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'ln -sf ../target subdir/name3' <$<
	GREP -qFx 'ln -sf ../target subdir/name4' <$<
clean-destdir: clean-destdir.log
	# Cleaning a symlink removes it.
	GREP -qFx 'rm -f name1' <$<
	GREP -qFx 'rm -f name2' <$<
	GREP -qFx 'rm -f subdir/name3' <$<
	GREP -qFx 'rm -f subdir/name4' <$<
install-destdir: install-destdir.log
	# Installing a symlink creates the install directory
	# and then places the symlink there.
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/some' <$<
	GREP -qFx 'install -d /destdir/some/path' <$<
	GREP -qFx 'ln -sf target /destdir/some/path/name1' <$<
	GREP -qFx 'ln -sf target /destdir/other/path/custom-install-name2' <$<
	GREP -qFx 'install -d /destdir/other' <$<
	GREP -qFx 'install -d /destdir/other/path' <$<
	GREP -qFx 'ln -sf ../target /destdir/other/path/name3' <$<
	GREP -qFx 'ln -sf ../target /destdir/other/path/custom-install-name4' <$<
uninstall-destdir: uninstall-destdir.log
	# Uninstalling a symlink removes it.
	GREP -qFx 'rm -f /destdir/some/path/name1' <$<
	GREP -qFx 'rm -f /destdir/other/path/custom-install-name2' <$<
	GREP -qFx 'rm -f /destdir/other/path/name3' <$<
	GREP -qFx 'rm -f /destdir/other/path/custom-install-name4' <$<
