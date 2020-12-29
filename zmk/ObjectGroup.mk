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

$(eval $(call ZMK.Import,Silent))
$(eval $(call ZMK.Import,Toolchain))
$(eval $(call ZMK.Import,OS))

# $1 is the object group name
# $2 is the source file (path)name
define ObjectGroup.COMPILE.c
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(CURDIR)/$$(dir $2)
	$$(call Silent.Say,CC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.c) -o $$@ $$<)
endef
define ObjectGroup.COMPILE.cc
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(CURDIR)/$$(dir $2)
	$$(call Silent.Say,CXX,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.cc) -o $$@ $$<)
endef
define ObjectGroup.COMPILE.m
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(CURDIR)/$$(dir $2)
	$$(call Silent.Say,OBJC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.m) -o $$@ $$<)
endef

ObjectGroup.Variables=Sources Objects ObjectsC ObjectsCxx ObjectsObjC
define ObjectGroup.Template
$1.Sources ?= $$(error define $1.Sources - the list of source files to compile)
$1.sourcesC = $$(filter %.c,$$($1.Sources))
$1.sourcesCxx = $$(filter %.cpp %.cxx %.cc,$$($1.Sources))
$1.sourcesObjc = $$(filter %.m,$$($1.Sources))
$1.ObjectsC ?= $$(foreach src,$$($1.sourcesC),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)
$1.ObjectsCxx ?= $$(foreach src,$$($1.sourcesCxx),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)
$1.ObjectsObjC ?= $$(foreach src,$$($1.sourcesObjc),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)
$1.Objects ?= $$(strip $$($1.ObjectsC) $$($1.ObjectsCxx) $$($1.ObjectsObjC))
$1.SuggestedLinkerSymbol ?= $$(if $$($1.ObjectsObjC),OBJCLD,$$(if $$($1.ObjectsCxx),CXXLD,CCLD))

# Check if we have the required compiler.
$$(if $$(or $$($1.ObjectsC),$$($1.ObjectsObjC)),$$(if $$(Toolchain.CC.IsAvailable),,$$(error Building $1 requires a C compiler)))
$$(if $$($1.ObjectsCxx),$$(if $$(Toolchain.CXX.IsAvailable),,$$(error Building $1 requires a C++ compiler)))

# This is how to compile each specific source file.
$$(foreach src,$$($1.sourcesC),$$(eval $$(call ObjectGroup.COMPILE.c,$1,$$(src))))
$$(foreach src,$$($1.sourcesCxx),$$(eval $$(call ObjectGroup.COMPILE.cc,$1,$$(src))))
$$(foreach src,$$($1.sourcesObjc),$$(eval $$(call ObjectGroup.COMPILE.m,$1,$$(src))))
# Create all support directories for out-of-tree builds
$$(foreach d,$$(filter-out ./,$$(sort $$(dir $$($1.Sources)))),$$(eval $$(call ZMK.Expand,Directory,$$(CURDIR)/$$d)))

ifneq (,$$($1.Objects))
clean::
	$$(call Silent.Say,RM,$$($1.Objects))
	$$(Silent.Command)rm -f $$($1.Objects)
ifneq (,$$(Toolchain.DependencyTracking))
	$$(call Silent.Say,RM,$$($1.Objects:.o=.d))
	$$(Silent.Command)rm -f $$($1.Objects:.o=.d)
endif

ifneq (,$$(Toolchain.DependencyTracking))
-include $$($1.Objects:.o=.d)
endif
endif # !no objects

endef
