export PATH := $(dir $(lastword $(MAKEFILE_LIST)))/bin:$(PATH)
TEST_OPTS += --warn-undefined-variables -B -n $(if $(value TEST_DEBUG),DEBUG=$(TEST_DEBUG))
TEST_HEADER = $(if $(filter s,$(MAKEFLAGS)),,@echo "\n****** $@ ******\n")
