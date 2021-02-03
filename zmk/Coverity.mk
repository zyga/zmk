# Copyright 2019-2021 Zygmunt Krynicki.
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

$(eval $(call ZMK.Import,Silent))

Coverity.Sources ?= $(error define Coverity.Sources - the list of source files to analyze with Coverity)
Coverity.ProjectName ?= $(error define Coverity.ProjectName - the name of the project as defined on scan.coverity.com)
Coverity.Email ?= $(error define Coverity.Email - email address of the scan submitter)
Coverity.Token ?= $(error define Coverity.Token - project access token)
Coverity.ScanURL ?= https://scan.coverity.com/builds

.PHONY: upload-coverity-scan
upload-coverity-scan: cov-int.$(NAME)-$(VERSION).tar.gz
	# Upload the tarball with the scan result.
	curl \
		--form token=$(Coverity.Token) \
		--form email=$(Coverity.Email) \
		--form file=@$< \
		--form version="$(Project.Version)" \
		--form description="Upload facilitated by zmk" \
		$(Coverity.ScanURL)?project=$(subst /,%2F,$(Coverity.ProjectName))

clean::
	$(call Silent.Say,RM,cov-int)
	$(Silent.Command)rm -rf cov-int
	$(call Silent.Say,RM,$(NAME)-$(VERSION)-coverity.tar.gz)
	$(Silent.Command)rm -f cov-int.$(NAME)-$(VERSION).tar.gz

cov-int: $(Coverity.Sources) $(MAKEFILE_LIST)
	$(call Silent.Say,COV-BUILD,$@)
	$(Silent.Command)cov-build --dir $@ $(MAKE) -B

# NOTE: We verify that over 80% of compilation units are ready for analysis as
# otherwise coverity will reject the archive and the scan will fail.
cov-int.$(NAME)-$(VERSION).tar.gz: cov-int cov-int/build-log.txt
	$(call Silent.Say,COV-INT-REJECT,$@)
	$(Silent.Command)test "$$(tail cov-int/build-log.txt -n 3 | awk -e '/[[:digit:]] C\/C\+\+ compilation units \([[:digit:]]+%) are ready for analysis/ { gsub(/[()%]/, "", $$6); print $$6; }')" -gt 80
	$(call Silent.Say,TAR,$@)
	$(Silent.Command)tar zcf $@ $<
