# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

all: all.log
	MATCH -qF 'cc -c -o hello-hello.o hello.c' <$<
	MATCH -qF 'cc -o hello hello-hello.o' <$<
install: install.log
	MATCH -qF 'install -d /usr/local/bin' <$<
	MATCH -qF 'install -m 0755 hello /usr/local/bin/hello' <$<
uninstall: uninstall.log
	MATCH -qF 'rm -f /usr/local/bin/hello' <$<
clean: clean.log
	MATCH -qF 'rm -f hello' <$<
	MATCH -qF 'rm -f hello-hello.o'  <$<
