#!/usr/bin/make -f
include zmk/internalTest.mk

t:: install

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directory
%.log: ZMK.makeOverrides += DESTDIR=/tmp

install: install.log
	# Extension of standard directory.
	GREP -qF 'install -d /tmp/usr/local/lib' <$<
	GREP -qF 'install -d /tmp/usr/local/lib/extra' <$<
	# Custom shallow directory.
	GREP -qF 'install -d /tmp/foo' <$<
	# Custom deep directory with implicit parent rules.
	GREP -qF 'install -d /tmp/custom/' <$<
	GREP -qF 'install -d /tmp/custom/long' <$<
	GREP -qF 'install -d /tmp/custom/long/path' <$<
	# Custom deep directory with explicit parent rules.
	GREP -qF 'install -d /tmp/other' <$<
	GREP -qF 'install -d /tmp/other/custom' <$<
	GREP -qF 'install -d /tmp/other/custom/path' <$<
