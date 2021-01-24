#!/usr/bin/make -f
include zmk/internalTest.mk

t:: check static-check

check: check.log
	# The check target depends on static-check
	GREP -qFx 'echo "target :check:"' <$<
	GREP -qFx 'echo "target :static-check:"' <$<

# internalTest.mk uses dashes to separate targets and
# cannot deduce a target that uses dashes itself.
# Provide the target explicitly with override.
static-check.log: ZMK.makeTarget=static-check
static-check: static-check.log
	# The static check target runs just the static checks. 
	GREP -qFx 'echo "target :static-check:"' <$<
	GREP -v -qFx 'echo "target :check:"' <$<
