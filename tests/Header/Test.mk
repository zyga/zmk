#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-destdir install-destdir uninstall-destdir clean-destdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=header
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.h

all: all.log
	GREP -qF 'Nothing to be done for' <$<
install: install.log
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)foo.h /usr/local/include/foo.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)include/bar.h /usr/local/include/bar.h' <$<
uninstall: uninstall.log
	GREP -qFx 'rm -f /usr/local/include/foo.h' <$<
	GREP -qFx 'rm -f /usr/local/include/bar.h' <$<
clean: clean.log
	GREP -qF 'Nothing to be done for' <$<

all-destdir: all-destdir.log
	GREP -qF 'Nothing to be done for' <$<
install-destdir: install-destdir.log
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)foo.h /destdir/usr/local/include/foo.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)include/bar.h /destdir/usr/local/include/bar.h' <$<
uninstall-destdir: uninstall-destdir.log
	GREP -qFx 'rm -f /destdir/usr/local/include/foo.h' <$<
	GREP -qFx 'rm -f /destdir/usr/local/include/bar.h' <$<
clean-destdir: clean-destdir.log
	GREP -qF 'Nothing to be done for' <$<
