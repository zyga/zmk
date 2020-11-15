#!/usr/bin/make -f
include zmk/internalTest.mk

t:: debug debug-silent-rules debug-destdir

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directory
# Some logs have slent rules enabled
%-silent-rules.log: ZMK.makeOverrides += Silent.Active=yes
# Some logs have DESTDIR set to /destdir
%-destdir.log: ZMK.makeOverrides += DESTDIR=/destdir

debug: debug.log
	# Directory in the build tree
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'install -d subdir/subsubdir' <$<
	# Extension of standard directory.
	GREP -qFx 'install -d /usr/local/lib' <$<
	GREP -qFx 'install -d /usr/local/lib/extra' <$<
	# Custom shallow directory.
	GREP -qFx 'install -d /foo' <$<
	# Custom deep directory with implicit parent rules.
	GREP -qFx 'install -d /custom' <$<
	GREP -qFx 'install -d /custom/long' <$<
	GREP -qFx 'install -d /custom/long/path' <$<
	# Custom deep directory with explicit parent rules.
	GREP -qFx 'install -d /other' <$<
	GREP -qFx 'install -d /other/custom' <$<
	GREP -qFx 'install -d /other/custom/path' <$<

debug-silent-rules: debug-silent-rules.log
	# Directory in the build tree
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "subdir"' <$<
	GREP -qFx '#install -d subdir' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "subdir/subsubdir"' <$<
	GREP -qFx '#install -d subdir/subsubdir' <$<
	# Extension of standard directory.
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr"' <$<
	GREP -qFx '#install -d /usr' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local"' <$<
	GREP -qFx '#install -d /usr/local' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local/lib"' <$<
	GREP -qFx '#install -d /usr/local/lib' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/usr/local/lib/extra"' <$<
	GREP -qFx '#install -d /usr/local/lib/extra' <$<
	# Custom shallow directory.
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/foo"' <$<
	GREP -qFx '#install -d /foo' <$<
	# Custom deep directory with implicit parent rules.
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/custom"' <$<
	GREP -qFx '#install -d /custom' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/custom/long"' <$<
	GREP -qFx '#install -d /custom/long' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/custom/long/path"' <$<
	GREP -qFx '#install -d /custom/long/path' <$<
	# Custom deep directory with explicit parent rules.
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/other"' <$<
	GREP -qFx '#install -d /other' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/other/custom"' <$<
	GREP -qFx '#install -d /other/custom' <$<
	GREP -qFx 'printf "  %-16s %s\n" "MKDIR" "/other/custom/path"' <$<
	GREP -qFx '#install -d /other/custom/path' <$<

debug-destdir: debug-destdir.log
	# Directory in the build tree - note lack of destdir
	GREP -qFx 'install -d subdir' <$<
	GREP -qFx 'install -d subdir/subsubdir' <$<
	# DESTDIR is created.
	GREP -qFx 'mkdir -p /destdir' <$<
	# Extension of standard directory.
	GREP -qFx 'install -d /destdir/usr/local/lib' <$<
	GREP -qFx 'install -d /destdir/usr/local/lib/extra' <$<
	# Custom shallow directory.
	GREP -qFx 'install -d /destdir/foo' <$<
	# Custom deep directory with implicit parent rules.
	GREP -qFx 'install -d /destdir/custom' <$<
	GREP -qFx 'install -d /destdir/custom/long' <$<
	GREP -qFx 'install -d /destdir/custom/long/path' <$<
	# Custom deep directory with explicit parent rules.
	GREP -qFx 'install -d /destdir/other' <$<
	GREP -qFx 'install -d /destdir/other/custom' <$<
	GREP -qFx 'install -d /destdir/other/custom/path' <$<
