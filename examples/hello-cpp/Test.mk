#!/usr/bin/make -f
# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean

# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++

all: all.log
	GREP -qFx 'c++ -MMD -c -o hello-hello.o hello.cpp' <$<
	GREP -qFx 'c++ -MMD -o hello hello-hello.o' <$<
install: install.log
	GREP -qFx 'install -d /usr/local/bin' <$<
	GREP -qFx 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	GREP -qFx 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	GREP -qFx 'rm -f hello' <$<
	GREP -qFx 'rm -f hello-hello.o'  <$<

