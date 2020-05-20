# Copyright 2019-2020 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

NAME = zmk
VERSION = 0.2  # This needs to match ZMK.Version

# Use the local copy of zmk rather than the system-wide one.
ZMK.Path =
include ./z.mk

# Use git to augment version.
$(eval $(call import,Module.git-version))
$(eval $(call import,Module.directories))

# Install all of zmk to the include directory.
$(foreach m,$(ZMK.DistFiles),$(eval $m.install_dir=$(includedir)))
$(foreach m,$(ZMK.DistFiles),$(eval $(call spawn,Template.data,$m)))

$(eval $(call spawn,Template.manpage,man/zmk.Template.program.5))

# Build the release tarball.
$(NAME)_$(VERSION).tar.gz.files = GNUmakefile README.md LICENSE NEWS
$(NAME)_$(VERSION).tar.gz.files += examples/hello/hello.c examples/hello/GNUmakefile
$(NAME)_$(VERSION).tar.gz.files += examples/true_false/true_false.c examples/true_false/Makefile
$(eval $(call spawn,Template.tarball.src,$(NAME)_$(VERSION).tar.gz))

check:: $(addprefix check,$(subst /,-,$(subst $(srcdir),,$(wildcard $(srcdir)/examples/*))))
check-examples-%:
	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* clean
	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* all
	rm -rf /tmp/zmk-example-$*
	$(MAKE) -I $(abspath $(srcdir)) --warn-undefined-variables -C $(srcdir)/examples/$* install DESTDIR=/tmp/zmk-example-$*
