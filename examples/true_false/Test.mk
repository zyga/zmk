# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all

all: all.log
	MATCH -qF 'cc -DEXIT_CODE=EXIT_SUCCESS -c -o true-true_false.o true_false.c' <$<
	MATCH -qF 'cc -o true true-true_false.o' <$<
	MATCH -qF 'cc -DEXIT_CODE=EXIT_FAILURE -c -o false-true_false.o true_false.c' <$<
	MATCH -qF 'cc -o false false-true_false.o' <$<
