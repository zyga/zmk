#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all

$(eval $(ZMK.isolateHostToolchain))

all: all.log
	GREP -qFx 'cc -MMD -DEXIT_CODE=EXIT_SUCCESS -c -o true-true_false.o $(ZMK.test.OutOfTreeSourcePath)true_false.c' <$<
	GREP -qFx 'cc -o true true-true_false.o' <$<
	GREP -qFx 'cc -MMD -DEXIT_CODE=EXIT_FAILURE -c -o false-true_false.o $(ZMK.test.OutOfTreeSourcePath)true_false.c' <$<
	GREP -qFx 'cc -o false false-true_false.o' <$<
