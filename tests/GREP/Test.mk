#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: run-shellcheck GREP-pass GREP-fail GREP-redirect

run-shellcheck:
	# If we have shellcheck, then GREP should pass it without issues.
	if [ -n "$$(command -v shellcheck)" ]; then shellcheck $(ZMK.Path)/tests/bin/GREP; fi

GREP-pass:
	# When GREP finds a match, the result is success.
	echo "marry had a little lamb" | GREP lamb

GREP-fail:
	# When GREP dose not find a match, the result is failure.
	! echo "marry had a little lamb" | GREP fox >/dev/null
	# The failure is accompanied by details of the failure.
	echo "marry had a little lamb" | GREP fox | grep -qFx 'GREP: failed to match: grep "fox"'
	# If the input is a one-liner it is printed this way.
	echo "marry had a little lamb" | GREP fox | grep -qFx 'GREP: for input "marry had a little lamb"'
	# If the input is longer, it is printed verbatim.
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "GREP: input starts below:"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "marry had"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "a little lamb"
	printf "marry had\na little lamb\n" | GREP fox | grep -qFx "GREP: input ends above."
	# The printed error output is correctly escaped.
	echo '"this is one thing"' | GREP that | grep -qFx 'GREP: for input "\"this is one thing\""'
	echo 'dollar is $$' | GREP cent | grep -qFx 'GREP: for input "dollar is \$$"'

GREP-redirect:
	# GREP, if invoked as the lower-case grep, redirects back to system grep.
	# Note that GREP describes itself as upper-case GREP in the usage string.
	./grep 2>&1 | grep -q 'usage: grep'
