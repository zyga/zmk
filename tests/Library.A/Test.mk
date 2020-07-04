#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-destdir install-destdir uninstall-destdir clean-destdir

$(eval $(ZMK.isolateHostToolchain))
# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=library.a
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.c

all: all.log
	GREP -qFx 'cc -MMD -c -o libfoo.a-foo.o $(ZMK.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'ar -cr libfoo.a libfoo.a-foo.o' <$<
install: install.log
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libfoo.a /usr/local/lib/libfoo.a' <$<
uninstall: uninstall.log
	GREP -qFx 'rm -f /usr/local/lib/libfoo.a' <$<
clean: clean.log
	GREP -qFx 'rm -f libfoo.a' <$<
	GREP -qFx 'rm -f libfoo.a-foo.o' <$<
	GREP -qFx 'rm -f libfoo.a-foo.d' <$<

all-destdir: all-destdir.log
	GREP -qFx 'cc -MMD -c -o libfoo.a-foo.o $(ZMK.OutOfTreeSourcePath)foo.c' <$<
	GREP -qFx 'ar -cr libfoo.a libfoo.a-foo.o' <$<
install-destdir: install-destdir.log
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	GREP -qFx 'install -m 0644 libfoo.a /destdir/usr/local/lib/libfoo.a' <$<
uninstall-destdir: uninstall-destdir.log
	GREP -qFx 'rm -f /destdir/usr/local/lib/libfoo.a' <$<
clean-destdir: clean-destdir.log
	GREP -qFx 'rm -f libfoo.a' <$<
	GREP -qFx 'rm -f libfoo.a-foo.o' <$<
	GREP -qFx 'rm -f libfoo.a-foo.d' <$<