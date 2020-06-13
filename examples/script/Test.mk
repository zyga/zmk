# This file is a part of zmk test system.
include ../../tests/Common.mk

t:: all install uninstall clean check

all: all.log
	MATCH -qF "make[1]: Nothing to be done for 'all'." <$<
install: install.log
	MATCH -qF 'install -d /usr/local/bin' <$<
	MATCH -qF 'install -m 0755 hello.sh /usr/local/bin/hello.sh' <$<
uninstall: uninstall.log
	MATCH -qF 'rm -f /usr/local/bin/hello.sh' <$<
	test `wc -l <$<` -eq 1
clean: clean.log
	MATCH -qF "make[1]: Nothing to be done for 'clean'." <$<
check: check-with-shellcheck check-without-shellcheck
check-with-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=shellcheck
check-with-shellcheck: check-with-shellcheck.log
	MATCH -qF 'shellcheck hello.sh' <$<
	test `wc -l <$<` -eq 1
check-without-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=
check-without-shellcheck: check-without-shellcheck.log
	MATCH -qF 'echo "ZMK: install shellcheck to analyze hello.sh"' <$<
	test `wc -l <$<` -eq 1