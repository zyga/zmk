#!/usr/bin/make -f
include zmk/internalTest.mk

t:: all clean install uninstall \
    all-destdir clean-destdir install-destdir uninstall-destdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=symlink
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir

all: all.log
	# Building a symlink just creates it.
	GREP -qFx 'ln -s target name' <$<
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'ln -s ../target subdir/name' <$<
clean: clean.log
	# Cleaning a symlink removes it.
	GREP -qFx 'rm -f name' <$<
	GREP -qFx 'rm -f subdir/name' <$<
install: install.log
	# Installing a symlink creates the install directory
	# and then places the symlink there.
	GREP -qFx 'install -d /some' <$<
	GREP -qFx 'install -d /some/path' <$<
	GREP -qFx 'ln -s target /some/path/name' <$<
	GREP -qFx 'install -d /other' <$<
	GREP -qFx 'install -d /other/path' <$<
	GREP -qFx 'ln -s ../target /other/path/subdir/name' <$<
uninstall: uninstall.log
	# Uninstalling a symlink removes it.
	GREP -qFx 'rm -f /some/path/name' <$<
	GREP -qFx 'rm -f /other/path/subdir/name' <$<


all-destdir: all-destdir.log
	# Building a symlink just creates it.
	GREP -qFx 'ln -s target name' <$<
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'ln -s ../target subdir/name' <$<
clean-destdir: clean-destdir.log
	# Cleaning a symlink removes it.
	GREP -qFx 'rm -f name' <$<
	GREP -qFx 'rm -f subdir/name' <$<
install-destdir: install-destdir.log
	# Installing a symlink creates the install directory
	# and then places the symlink there.
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/some' <$<
	GREP -qFx 'install -d /destdir/some/path' <$<
	GREP -qFx 'ln -s target /destdir/some/path/name' <$<
	GREP -qFx 'install -d /destdir/other' <$<
	GREP -qFx 'install -d /destdir/other/path' <$<
	GREP -qFx 'ln -s ../target /destdir/other/path/subdir/name' <$<
uninstall-destdir: uninstall-destdir.log
	# Uninstalling a symlink removes it.
	GREP -qFx 'rm -f /destdir/some/path/name' <$<
	GREP -qFx 'rm -f /destdir/other/path/subdir/name' <$<
