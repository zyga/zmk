#!/usr/bin/make -f
include zmk/internalTest.mk

t:: clean distclean

clean: clean.log
	# The clean target run the clean but not the distclean command.
	GREP -qFx 'echo "target :clean:"' <$<
	GREP -v -qFx 'echo "target :distclean:"' <$<

distclean: distclean.log
	# The distclean target run both the clean and the distclean command.
	GREP -qFx 'echo "target :clean:"' <$<
	GREP -qFx 'echo "target :distclean:"' <$<
