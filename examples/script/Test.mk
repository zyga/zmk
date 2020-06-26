# This file is a part of zmk test system.
include zmk/internalTest.mk

t:: all install uninstall clean check

all: all.log
	GREP -q "Nothing to be done for [\`']all'\." <$<
install: install.log
	GREP -qF 'install -d /usr/local/bin' <$<
	GREP -qF 'install -m 0755 hello.sh /usr/local/bin/hello.sh' <$<
uninstall: uninstall.log
	GREP -qF 'rm -f /usr/local/bin/hello.sh' <$<
clean: clean.log
	GREP -q "Nothing to be done for [\`']clean'\." <$<
check: check-with-shellcheck check-without-shellcheck
check-with-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=shellcheck
check-with-shellcheck: check-with-shellcheck.log
	GREP -qF 'shellcheck hello.sh' <$<
check-without-shellcheck.log: ZMK.makeOverrides = ZMK.shellcheck=
check-without-shellcheck: check-without-shellcheck.log
	GREP -qF 'echo "ZMK: install shellcheck to analyze hello.sh"' <$<
