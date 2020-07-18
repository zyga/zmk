#!/usr/bin/make -f
include zmk/internalTest.mk

t:: dist-gnu dist-non-gnu dist-darwin dist-CI

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=tarball

# Unset CI if we happen to see one from the likes of GitHub Actions or Travis
%.log: ZMK.makeOverrides += CI=

dist-gnu.log: ZMK.makeOverrides += Tarball.isGNU=yes
dist-gnu: dist-gnu.log
	# Archiving source release tarball archives the files given by the user
	GREP -qF 'tar -zcf test_1.tar.gz -C . ' <$<
	GREP -qF 'foo.txt' <$<
	# It also archives zmk (only parts are tested)
	GREP -qF 'z.mk' <$<
	GREP -qF 'zmk/Configure.mk' <$<
	GREP -qF 'zmk/pvs-filter.awk' <$<
	# GNU-specific transformation syntax is supported.
	GREP -qF -- "--xform='s@^@test_1/@g'" <$<
	GREP -qF -- "--xform='s@.version-from-git@.version@'" <$<
	# Releases are also signed
	GREP -qFx 'gpg --detach-sign --armor test_1.tar.gz' <$<

dist-non-gnu.log: ZMK.makeOverrides += Tarball.isGNU= OS.Kernel=test
dist-non-gnu: dist-non-gnu.log
	# Archiving source release tarball archives the files given by the user
	GREP -qF 'tar -zcf test_1.tar.gz -C . ' <$<
	GREP -qF 'foo.txt' <$<
	# It also archives zmk (only parts are tested)
	GREP -qF 'z.mk' <$<
	GREP -qF 'zmk/Configure.mk' <$<
	GREP -qF 'zmk/pvs-filter.awk' <$<
	# BSD-specific transformation syntax is supported.
	GREP -qF -- "-s '@.@test_1/~@'" <$<
	GREP -qF -- "-s '@.version-from-git@.version@'" <$<
	# Releases are also signed
	GREP -qFx 'gpg --detach-sign --armor test_1.tar.gz' <$<

dist-darwin.log: ZMK.makeOverrides += OS.Kernel=Darwin
dist-darwin.log: ZMK.makeOverrides += Tarball.isGNU=
dist-darwin: dist-darwin.log
	# Darwin meta-data is excluded.
	GREP -qF 'tar --no-mac-metadata -zcf test_1.tar.gz -C . ' <$<

dist-CI.log: ZMK.makeOverrides += CI=fake
dist-CI: dist-CI.log
	# When CI is set release archives are not signed
	GREP -vqFx 'gpg --detach-sign --armor test_1.tar.gz' <$<
