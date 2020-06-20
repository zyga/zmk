#!/usr/bin/make -f
# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

all: all.log
	MATCH -qFx 'cc -MMD -c -o hello-hello.o hello.m' <$<
	MATCH -qFx 'cc -MMD -o hello hello-hello.o -lobjc' <$<
install: install.log
	MATCH -qFx 'install -d /usr/local/bin' <$<
	MATCH -qFx 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	MATCH -qFx 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	MATCH -qFx 'rm -f hello' <$<
	MATCH -qFx 'rm -f hello-hello.o'  <$<
