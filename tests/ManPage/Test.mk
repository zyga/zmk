#!/usr/bin/make -f
include zmk/internalTest.mk

t:: install install-destdir uninstall

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=manpage
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir

install: install.log
	# Prerequisite directories are created
	GREP -qFx 'install -d /usr' <$<
	GREP -qFx 'install -d /usr/local' <$<
	GREP -qFx 'install -d /usr/local/share' <$<
	GREP -qFx 'install -d /usr/local/share/man' <$<
	# The install target installs manual pages and the directories they belong to.
	GREP -qFx 'install -d /usr/local/share/man/man1' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.1 /usr/local/share/man/man1/foo.1' <$<
	GREP -qFx 'install -d /usr/local/share/man/man2' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.2 /usr/local/share/man/man2/foo.2' <$<
	GREP -qFx 'install -d /usr/local/share/man/man3' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.3 /usr/local/share/man/man3/foo.3' <$<
	GREP -qFx 'install -d /usr/local/share/man/man4' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.4 /usr/local/share/man/man4/foo.4' <$<
	GREP -qFx 'install -d /usr/local/share/man/man5' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.5 /usr/local/share/man/man5/foo.5' <$<
	GREP -qFx 'install -d /usr/local/share/man/man6' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.6 /usr/local/share/man/man6/foo.6' <$<
	GREP -qFx 'install -d /usr/local/share/man/man7' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.7 /usr/local/share/man/man7/foo.7' <$<
	GREP -qFx 'install -d /usr/local/share/man/man8' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.8 /usr/local/share/man/man8/foo.8' <$<
	GREP -qFx 'install -d /usr/local/share/man/man9' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.9 /usr/local/share/man/man9/foo.9' <$<
	# Manual pages that are provided by path locally are not retaining that path
	# in the installed location. If desired this can be customised by setting
	# InstallDir on the appropriate objects.
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.1 /usr/local/share/man/man1/bar.1' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.2 /usr/local/share/man/man2/bar.2' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.3 /usr/local/share/man/man3/bar.3' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.4 /usr/local/share/man/man4/bar.4' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.5 /usr/local/share/man/man5/bar.5' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.6 /usr/local/share/man/man6/bar.6' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.7 /usr/local/share/man/man7/bar.7' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.8 /usr/local/share/man/man8/bar.8' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.9 /usr/local/share/man/man9/bar.9' <$<

install-destdir: install-destdir.log
	# Destdir is created
	GREP -qFx 'mkdir -p /destdir' <$<
	# Prerequisite directories are created
	GREP -qFx 'install -d /destdir/usr' <$<
	GREP -qFx 'install -d /destdir/usr/local' <$<
	GREP -qFx 'install -d /destdir/usr/local/share' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man' <$<
	# The install target installs manual pages and the directories they belong to.
	GREP -qFx 'install -d /destdir/usr/local/share/man/man1' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.1 /destdir/usr/local/share/man/man1/foo.1' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man2' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.2 /destdir/usr/local/share/man/man2/foo.2' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man3' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.3 /destdir/usr/local/share/man/man3/foo.3' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man4' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.4 /destdir/usr/local/share/man/man4/foo.4' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man5' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.5 /destdir/usr/local/share/man/man5/foo.5' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man6' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.6 /destdir/usr/local/share/man/man6/foo.6' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man7' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.7 /destdir/usr/local/share/man/man7/foo.7' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man8' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.8 /destdir/usr/local/share/man/man8/foo.8' <$<
	GREP -qFx 'install -d /destdir/usr/local/share/man/man9' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)foo.9 /destdir/usr/local/share/man/man9/foo.9' <$<
	# Manual pages that are provided by path locally are not retaining that path
	# in the installed location. If desired this can be customised by setting
	# InstallDir on the appropriate objects.
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.1 /destdir/usr/local/share/man/man1/bar.1' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.2 /destdir/usr/local/share/man/man2/bar.2' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.3 /destdir/usr/local/share/man/man3/bar.3' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.4 /destdir/usr/local/share/man/man4/bar.4' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.5 /destdir/usr/local/share/man/man5/bar.5' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.6 /destdir/usr/local/share/man/man6/bar.6' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.7 /destdir/usr/local/share/man/man7/bar.7' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.8 /destdir/usr/local/share/man/man8/bar.8' <$<
	GREP -qFx 'install -m 0644 $(ZMK.OutOfTreeSourcePath)man/bar.9 /destdir/usr/local/share/man/man9/bar.9' <$<

uninstall: uninstall.log
	# The uninstall target removes manual pages.
	GREP -qFx 'rm -f /usr/local/share/man/man1/foo.1' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man2/foo.2' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man3/foo.3' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man4/foo.4' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man5/foo.5' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man6/foo.6' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man7/foo.7' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man8/foo.8' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man9/foo.9' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man1/bar.1' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man2/bar.2' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man3/bar.3' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man4/bar.4' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man5/bar.5' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man6/bar.6' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man7/bar.7' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man8/bar.8' <$<
	GREP -qFx 'rm -f /usr/local/share/man/man9/bar.9' <$<
