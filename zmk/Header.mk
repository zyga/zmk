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

$(eval $(call ZMK.Import,Directories))

$(DESTDIR)$(includedir)/%.h: %.h | $(DESTDIR)$(includedir)
	install -m 0644 $^ $@

Header.Variables=
define Header.Template
install:: $$(DESTDIR)$$(includedir)/$1
uninstall::
	rm -f $$(DESTDIR)$$(includedir)/$1
endef
