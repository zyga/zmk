# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean

all: all.log
	MATCH -qF 'cc -c -o hello-hello.o hello.m' <$<
	MATCH -qF 'cc -o hello hello-hello.o -lobjc' <$<
	test `wc -l <$<` -eq 2
install: install.log
	MATCH -qF 'install -d /usr/local/bin' <$<
	MATCH -qF 'install -m 0755 hello /usr/local/bin/hello' <$<
	test `wc -l <$<` -eq 4 # 2 for all, 2 for install
uninstall: uninstall.log
	MATCH -qF 'rm -f /usr/local/bin/hello' <$<
	test `wc -l <$<` -eq 1
clean: clean.log
	MATCH -qF 'rm -f hello' <$<
	MATCH -qF 'rm -f hello-hello.o'  <$<
	test `wc -l <$<` -eq 2
