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

coverity.sources ?= $(error define coverity.sources - the list of source files to analyze with Coverity)

clean::
	rm -rf cov-int
	rm -f $(NAME)-$(VERSION)-coverity.tar.gz

cov-int: $(coverity.sources) $(MAKEFILE_LIST)
	cov-build --dir $@ $(MAKE)

$(NAME)-$(VERSION)-coverity.tar.gz: cov-int
	tar zcf $@ $<
