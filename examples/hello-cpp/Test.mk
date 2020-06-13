# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

# MacOS uses c++, GNU uses g++ by default.
# Pick one for test consistency.
%.log: ZMK.makeOverrides += CXX=c++

all: all.log
	MATCH -qF 'c++ -c -o hello-hello.o hello.cpp' <$<
	MATCH -qF 'c++ -o hello hello-hello.o' <$<
install: install.log
	MATCH -qF 'install -d /usr/local/bin' <$<
	MATCH -qF 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	MATCH -qF 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	MATCH -qF 'rm -f hello' <$<
	MATCH -qF 'rm -f hello-hello.o'  <$<

