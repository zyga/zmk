#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean \
    all-silent-rules install-silent-rules uninstall-silent-rules clean-silent-rules \
    all-destdir install-destdir uninstall-destdir clean-destdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=header
# Some logs have slent rules enabled
%-silent-rules.log: ZMK.makeOverrides += Silent.Active=yes
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir
# Test depends on source files
%.log: foo.h include/bar.h froz.h

all: all.log
	GREP -qF 'Nothing to be done for' <$<
install: install.log
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/include' <$<
	GREP -qFx 'install -d /usr/local/include/froz' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)foo.h /usr/local/include/foo.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)include/bar.h /usr/local/include/bar.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)froz.h /usr/local/include/froz/froz.h' <$<
uninstall: uninstall.log
	GREP -qFx 'rm -f /usr/local/include/foo.h' <$<
	GREP -qFx 'rm -f /usr/local/include/bar.h' <$<
	GREP -qFx 'rm -f /usr/local/include/froz/froz.h' <$<
clean: clean.log
	GREP -qF 'Nothing to be done for' <$<

all-silent-rules: all-silent-rules.log
	GREP -qF 'Nothing to be done for' <$<
install-silent-rules: install-silent-rules.log
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr"' <$<
	GREP -qFx '#install -d /usr' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local"' <$<
	GREP -qFx '#install -d /usr/local' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local/include"' <$<
	GREP -qFx '#install -d /usr/local/include' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local/include/froz"' <$<
	GREP -qFx '#install -d /usr/local/include/froz' <$<
	GREP -qFx 'printf "  %-16s %s\n" "INSTALL" "/usr/local/include/foo.h"' <$<
	GREP -qFx '#install -m 0644 $(ZMK.test.OutOfTreeSourcePath)foo.h /usr/local/include/foo.h' <$<
	GREP -qFx 'printf "  %-16s %s\n" "INSTALL" "/usr/local/include/bar.h"' <$<
	GREP -qFx '#install -m 0644 $(ZMK.test.OutOfTreeSourcePath)include/bar.h /usr/local/include/bar.h' <$<
	GREP -qFx 'printf "  %-16s %s\n" "INSTALL" "/usr/local/include/froz/froz.h"' <$<
	GREP -qFx '#install -m 0644 $(ZMK.test.OutOfTreeSourcePath)froz.h /usr/local/include/froz/froz.h' <$<
uninstall-silent-rules: uninstall-silent-rules.log
	GREP -qFx 'printf "  %-16s %s\n" "RM" "/usr/local/include/foo.h"' <$<
	GREP -qFx '#rm -f /usr/local/include/foo.h' <$<
	GREP -qFx 'printf "  %-16s %s\n" "RM" "/usr/local/include/bar.h"' <$<
	GREP -qFx '#rm -f /usr/local/include/bar.h' <$<
	GREP -qFx 'printf "  %-16s %s\n" "RM" "/usr/local/include/froz/froz.h"' <$<
	GREP -qFx '#rm -f /usr/local/include/froz/froz.h' <$<
clean-silent-rules: clean-silent-rules.log
	GREP -qF 'Nothing to be done for' <$<

all-destdir: all-destdir.log
	GREP -qF 'Nothing to be done for' <$<
install-destdir: install-destdir.log
	GREP -qFx 'mkdir -p /destdir' <$<
	GREP -qFx 'install -d /destdir/usr/local/include' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)foo.h /destdir/usr/local/include/foo.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)include/bar.h /destdir/usr/local/include/bar.h' <$<
	GREP -qFx 'install -m 0644 $(ZMK.test.OutOfTreeSourcePath)froz.h /destdir/usr/local/include/froz/froz.h' <$<
uninstall-destdir: uninstall-destdir.log
	GREP -qFx 'rm -f /destdir/usr/local/include/foo.h' <$<
	GREP -qFx 'rm -f /destdir/usr/local/include/bar.h' <$<
	GREP -qFx 'rm -f /destdir/usr/local/include/froz/froz.h' <$<
clean-destdir: clean-destdir.log
	GREP -qF 'Nothing to be done for' <$<
