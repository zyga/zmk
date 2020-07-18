#!/usr/bin/make -f
include zmk/internalTest.mk

t:: dist dist-CI

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=tarball

# Unset CI if we happen to see one from the likes of GitHub Actions or Travis
dist.log: ZMK.makeOverrides += CI=
dist: dist.log
	# Archiving source release tarball archives the files given by the user
	GREP -qF 'tar -zcf test_1.tar.gz -C . ' <$<
	GREP -qF 'foo.txt' <$<
	# It also archives zmk (only parts are tested)
	GREP -qF 'z.mk' <$<
	GREP -qF 'zmk/Configure.mk' <$<
	GREP -qF 'zmk/pvs-filter.awk' <$<
	# Releases are also signed
	GREP -qFx 'gpg --detach-sign --armor test_1.tar.gz' <$<

dist-CI.log: ZMK.makeOverrides += CI=fake
dist-CI: dist-CI.log
	# When CI is set release archives are not signed
	GREP -vqFx 'gpg --detach-sign --armor test_1.tar.gz' <$<
