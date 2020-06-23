#!/usr/bin/make -f
include zmk/internalTest.mk

t:: install

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directory
%.log: ZMK.makeOverrides += DESTDIR=/tmp

install: install.log
	GREP -qF 'install -d /tmp/foo' <$<
