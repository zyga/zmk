#!/usr/bin/make -f
include ../Common.mk

t:: \
	configure-shellcheck \
	configure-enable-option-checking \
	configure-disable-option-checking \
	debug-defaults \
	debug-configure \
	configured-defaults \
	configured-build \
	configured-host \
	configured-enable-dependency-tracking \
	configured-disable-dependency-tracking \
	configured-enable-maintainer-mode \
	configured-disable-maintainer-mode \
	configured-enable-silent-rules \
	configured-disable-silent-rules \
	configured-program-prefix \
	configured-program-suffix \
	configured-program-transform-name \
	configured-prefix \
	configured-bindir \
	configured-sbindir \
	configured-libdir \
	configured-libexecdir \
	configured-includedir \
	configured-mandir \
	configured-infodir \
	configured-sysconfdir \
	configured-datadir \
	configured-localstatedir \
	configured-runstatedir \
	configured-sharedstatedir \

# Test logs will contain debugging messages specific to the configure module
%.log: ZMK.makeOverrides += DEBUG=configure

# The configure script is generated.
configure: Makefile $(ZMK.Path)/tests/Common.mk $(ZMK.Path)/z.mk $(wildcard $(ZMK.Path)/zmk/*.mk)
	$(MAKE) -I $(ZMK.Path) $@
c::
	rm -f configure

# The configure script writes a configuration file.
# Note that normally the file is GNUmakefile.configure.mk but
# the test redirects that to a different file to enable parallelism.
configureOptions ?=
configured.%.mk: configure Test.mk
	$(strip ZMK_CONFIGURE_MAKEFILE=$@ ./$< $(configureOptions))
c::
	rm -f configured.*.mk

configure-shellcheck: configure
	shellcheck $<

configure-enable-option-checking: export ZMK_CONFIGURE_MAKEFILE=configured.enable-option-checking.mk
configure-enable-option-checking: configure
	./$< --enable-option-checking --foo 2>&1 | MATCH -qFx 'configure: unknown option --foo'
	! ./$< --enable-option-checking --foo 2>/dev/null
	test ! -e $(ZMK_CONFIGURE_MAKEFILE)

configure-disable-option-checking: export ZMK_CONFIGURE_MAKEFILE=configured.disable-option-checking.mk
configure-disable-option-checking: configure
	./$< --disable-option-checking --foo

debug-defaults: debug-defaults.log
	# Debug messages show the state of internal variables.
	# Note that here we also measure the default values of an un-configured build.
	MATCH -qFx 'DEBUG: Configure.HostArchTriplet=' <$<
	MATCH -qFx 'DEBUG: Configure.BuildArchTriplet=' <$<
	MATCH -qFx 'DEBUG: Configure.DependencyTracking=yes' <$<
	MATCH -qFx 'DEBUG: Configure.MaintainerMode=yes' <$<
	MATCH -qFx 'DEBUG: Configure.SilentRules=' <$<
	MATCH -qFx 'DEBUG: Configure.ProgramPrefix=' <$<
	MATCH -qFx 'DEBUG: Configure.ProgramSuffix=' <$<
	MATCH -qFx 'DEBUG: Configure.ProgramTransformName=' <$<
	MATCH -qFx 'DEBUG: Configure.Configured=' <$<
	MATCH -qFx 'DEBUG: Configure.Options=' <$<

debug-configure.log: ZMK.makeTarget=configure
debug-configure: debug-configure.log
	# The configure script can be remade.
	MATCH -qF 'echo "$${ZMK_CONFIGURE_SCRIPT}" >configure' <$<

configured-defaults: configured.defaults.mk
	# Minimal defaults are set
	MATCH -qFx 'srcdir=.' <$<
	MATCH -qFx 'VPATH=$$(srcdir)' <$<$
	MATCH -qFx 'Configure.Configured=yes' <$<
	MATCH -qFx 'Configure.Options=' <$<
	# Other options are not explicitly set.
	# Note the lack of whole-line matching (-x).
	MATCH -v -qF 'Configure.BuildArchTriplet=' <$<
	MATCH -v -qF 'Configure.HostArchTriplet=' <$<
	MATCH -v -qF 'Configure.DependencyTracking=' <$<
	MATCH -v -qF 'Configure.MaintainerMode=' <$<
	MATCH -v -qF 'Configure.SilentRules=' <$<
	MATCH -v -qF 'Configure.ProgramPrefix=' <$<
	MATCH -v -qF 'Configure.ProgramSuffix=' <$<
	MATCH -v -qF 'Configure.ProgramTransformName=' <$<

configured.build.mk: configureOptions += --build=foo-linux-gnu
configured-build: configured.build.mk
	# configure --build= sets Configure.BuildArchTriplet
	MATCH -qFx 'Configure.BuildArchTriplet=foo-linux-gnu' <$<
	MATCH -qFx 'Configure.Options=--build=foo-linux-gnu' <$<

configured.host.mk: configureOptions += --host=foo-linux-gnu
configured-host: configured.host.mk
	# configure --host= sets Configure.HostArchTriplet
	MATCH -qFx 'Configure.HostArchTriplet=foo-linux-gnu' <$<

configured.enable-dependency-tracking.mk: configureOptions += --enable-dependency-tracking
configured-enable-dependency-tracking: configured.enable-dependency-tracking.mk
	# configure --enable-dependency-tracking sets Configure.DependencyTracking=yes
	MATCH -qFx 'Configure.DependencyTracking=yes' <$<

configured.disable-dependency-tracking.mk: configureOptions += --disable-dependency-tracking
configured-disable-dependency-tracking: configured.disable-dependency-tracking.mk
	# configure --disable-dependency-tracking sets Configure.DependencyTracking= (empty but set)
	MATCH -qFx 'Configure.DependencyTracking=' <$<

configured.enable-maintainer-mode.mk: configureOptions += --enable-maintainer-mode
configured-enable-maintainer-mode: configured.enable-maintainer-mode.mk
	# configure --enable-maintainer-mode sets Configure.MaintainerMode=yes
	MATCH -qFx 'Configure.MaintainerMode=yes' <$<

configured.disable-maintainer-mode.mk: configureOptions += --disable-maintainer-mode
configured-disable-maintainer-mode: configured.disable-maintainer-mode.mk
	# configure --disable-dependency-tracking sets Configure.MaintainerMode= (empty but set)
	MATCH -qFx 'Configure.MaintainerMode=' <$<

configured.enable-silent-rules.mk: configureOptions += --enable-silent-rules
configured-enable-silent-rules: configured.enable-silent-rules.mk
	# configure --enable-silent-rules sets Configure.SilentRules=yes
	MATCH -qFx 'Configure.SilentRules=yes' <$<

configured.disable-silent-rules.mk: configureOptions += --disable-silent-rules
configured-disable-silent-rules: configured.disable-silent-rules.mk
	# configure --disable-dependency-tracking sets Configure.SilentRules= (empty but set)
	MATCH -qFx 'Configure.SilentRules=' <$<

configured.program-prefix.mk: configureOptions += --program-prefix=awesome-
configured-program-prefix: configured.program-prefix.mk
	# configure --program-prefix=foo sets Configure.ProgramPrefix=foo
	MATCH -qFx 'Configure.ProgramPrefix=awesome-' <$<

configured.program-suffix.mk: configureOptions += --program-suffix=-real
configured-program-suffix: configured.program-suffix.mk
	# configure --program-suffix=foo sets Configure.ProgramSuffix=foo
	MATCH -qFx 'Configure.ProgramSuffix=-real' <$<

configured.program-transform-name.mk: configureOptions += --program-transform-name=s/foo/bar/
configured-program-transform-name: configured.program-transform-name.mk
	# configure --program-transform-name=foo sets Configure.ProgramTransformName=foo
	MATCH -qFx 'Configure.ProgramTransformName=s/foo/bar/' <$<

configured.prefix.mk: configureOptions += --prefix=/foo
configured-prefix: configured.prefix.mk
	# configure --prefix=/foo sets prefix=/foo
	MATCH -qFx 'prefix=/foo' <$<

configured.exec-prefix.mk: configureOptions += --exec-prefix=/foo
configured-exec-prefix: configured.exec-prefix.mk
	# configure --exec-prefix=/foo sets exec_prefix=/foo
	MATCH -qFx 'exec_prefix=/foo' <$<

dirs=bindir sbindir libdir libexecdir includedir mandir infodir sysconfdir datadir localstatedir runstatedir sharedstatedir
$(foreach d,$(dirs),configured.$d.mk): configureOptions += --$*=/foo
$(addprefix configured-,$(dirs)): configured-%: configured.%.mk
	# configure --$*=/foo sets $*=/foo
	MATCH -qFx '$*=/foo' <$<