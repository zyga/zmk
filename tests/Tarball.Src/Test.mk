#!/usr/bin/make -f
include zmk/internalTest.mk

t:: dist-gnu dist-non-gnu dist-darwin dist-CI

# Test logs will contain debugging messages
%.log: ZMK.makeOverrides += DEBUG=tarball

# Test logs will specialize for either GNU tar or BSD tar
%-gnu.log: ZMK.makeOverrides += Tarball.tar=/usr/bin/tar Tarball.isGNU=yes
%-bsd.log: ZMK.makeOverrides += Tarball.tar=/usr/bin/tar Tarball.isGNU=

# Unset CI if we happen to see one from the likes of GitHub Actions or Travis
%.log: ZMK.makeOverrides += CI=

dist-gnu.log: ZMK.makeOverrides += Tarball.isGNU=yes OS.Kernel=test
dist-gnu: dist-gnu.log
	# Archiving source release tarball archives the files given by the user
	GREP -qF "/usr/bin/tar -zcf test_1.tar.gz$(if $(ZMK.OutOfTreeBuild), -C $(ZMK.SrcDir)) --absolute-names " <$<
	GREP -qF ' foo.txt' <$<
	# It also archives zmk (only parts are tested)
	GREP -qF '$(ZMK.Path)/z.mk' <$<
	GREP -qF '$(ZMK.Path)/zmk/Configure.mk' <$<
	GREP -qF '$(ZMK.Path)/zmk/pvs-filter.awk' <$<
	# GNU-specific transformation syntax is supported.
	GREP -qF -- " --xform='s@$(CURDIR)/@@g' " <$<
	GREP -qF -- " --xform='s@$(ZMK.Path)/@@g' " <$<
	GREP -qF -- " --xform='s@.version-from-git@.version@' " <$<
	GREP -qF -- " --xform='s@^@test_1/@' " <$<
	# Releases are also signed
	GREP -qFx 'gpg --detach-sign --armor test_1.tar.gz' <$<

dist-non-gnu.log: ZMK.makeOverrides += Tarball.isGNU= OS.Kernel=test
dist-non-gnu: dist-non-gnu.log
	# Archiving source release tarball archives the files given by the user
	GREP -qF "/usr/bin/tar -zcf test_1.tar.gz$(if $(ZMK.OutOfTreeBuild), -C $(ZMK.SrcDir)) " <$<
	GREP -qF ' foo.txt' <$<
	# It also archives zmk (only parts are tested)
	GREP -qF '$(ZMK.Path)/z.mk' <$<
	GREP -qF '$(ZMK.Path)/zmk/Configure.mk' <$<
	GREP -qF '$(ZMK.Path)/zmk/pvs-filter.awk' <$<
	# BSD-specific transformation syntax is supported.
	GREP -qF -- " -s '@$(CURDIR)/@@g' " <$<
	GREP -qF -- " -s '@$(ZMK.Path)/@@g' " <$<
	GREP -qF -- " -s '@^.version-from-git@test_1/.version@' " <$<
	GREP -qF -- " -s '@^.@test_1/~@' " <$<
	# Releases are also signed
	GREP -qFx 'gpg --detach-sign --armor test_1.tar.gz' <$<

dist-darwin.log: ZMK.makeOverrides += OS.Kernel=Darwin
dist-darwin.log: ZMK.makeOverrides += Tarball.isGNU=
dist-darwin: dist-darwin.log
	# Darwin meta-data is excluded.
	GREP -qF 'tar -zcf test_1.tar.gz --no-mac-metadata ' <$<

dist-CI.log: ZMK.makeOverrides += CI=fake
dist-CI: dist-CI.log
	# When CI is set release archives are not signed
	GREP -vqFx 'gpg --detach-sign --armor test_1.tar.gz' <$<
