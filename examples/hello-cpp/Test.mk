#!/usr/bin/make -f
# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++

all: all.log
	MATCH -qFx 'c++ -MMD -c -o hello-hello.o hello.cpp' <$<
	MATCH -qFx 'c++ -MMD -o hello hello-hello.o' <$<
install: install.log
	MATCH -qFx 'install -d /usr/local/bin' <$<
	MATCH -qFx 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	MATCH -qFx 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	MATCH -qFx 'rm -f hello' <$<
	MATCH -qFx 'rm -f hello-hello.o'  <$<

