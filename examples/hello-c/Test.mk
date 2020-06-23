#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean

all: all.log
	MATCH -qFx 'cc -MMD -c -o hello-hello.o hello.c' <$<
	MATCH -qFx 'cc -o hello hello-hello.o' <$<
install: install.log
	MATCH -qFx 'install -d /usr/local/bin' <$<
	MATCH -qFx 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	MATCH -qFx 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	MATCH -qFx 'rm -f hello' <$<
	MATCH -qFx 'rm -f hello-hello.o'  <$<
