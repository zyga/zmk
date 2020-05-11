# This file is a part of zmk test system.
include ../../tests/Common.mk

.PHONY: check


check:: check-build
check-build:
	$(TEST_HEADER)
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -DEXIT_CODE=EXIT_SUCCESS -c -o true-true_false.o true_false.c'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -o true true-true_false.o'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -DEXIT_CODE=EXIT_FAILURE -c -o false-true_false.o true_false.c'
	$(MAKE) $(TEST_OPTS) all | MATCH -qF 'cc -o false false-true_false.o'
