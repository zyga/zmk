include ../Common.mk

t:: install

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=directory
%.log: ZMK.makeOverrides += DESTDIR=/tmp

install: install.log
	MATCH -qF 'install -d /tmp/foo' <$<
