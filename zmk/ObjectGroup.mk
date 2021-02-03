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
$(eval $(call ZMK.Import,Toolchain))
$(eval $(call ZMK.Import,OS))

# $1 is the object group name
# $2 is the source file (path)name
define ObjectGroup.COMPILE.c
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(patsubst %/,%,$$(CURDIR)/$$(dir $2))
	$$(call Silent.Say,CC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.c) -o $$@ $$<)
endef
define ObjectGroup.COMPILE.cc
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(patsubst %/,%,$$(CURDIR)/$$(dir $2))
	$$(call Silent.Say,CXX,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.cc) -o $$@ $$<)
endef
define ObjectGroup.COMPILE.m
$$(dir $2)$1-$$(basename $$(notdir $2)).o: $$(ZMK.OutOfTreeSourcePath)$2 | $$(patsubst %/,%,$$(CURDIR)/$$(dir $2))
	$$(call Silent.Say,OBJC,$$@)
	$$(Silent.Command)$$(strip $$(COMPILE.m) -o $$@ $$<)
endef

ObjectGroup.Variables=Sources Objects ObjectsC ObjectsCxx ObjectsObjC
define ObjectGroup.Template
# Sources are not re-defined with := so that they can expand lazily.
$1.Sources ?= $$(error define $1.Sources - the list of source files to compile)
# NOTE: Strip out the out-of-tree-source-path so that all the $1.sources (note
# the lower-case) variables use source-relative paths. This is important when
# we want to derive object paths using source paths (same file with .o
# extension replaced but rooted at the build tree, not the source tree). When
# ZMK needs to support generated source files this should be changed.
$1.sources = $$(patsubst $$(ZMK.OutOfTreeSourcePath)%,%,$$($1.Sources))

$1.sourcesC = $$(filter %.c,$$($1.sources))
$1.sourcesCxx = $$(filter %.cpp %.cxx %.cc,$$($1.sources))
$1.sourcesObjC = $$(filter %.m,$$($1.sources))

# Object files contain the object group name prepndend to the file name and the extension replaced with .o
$1.ObjectsC ?= $$(foreach src,$$($1.sourcesC),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)
$1.ObjectsCxx ?= $$(foreach src,$$($1.sourcesCxx),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)
$1.ObjectsObjC ?= $$(foreach src,$$($1.sourcesObjC),$$(dir $$(src))$1-$$(basename $$(notdir $$(src))).o)

$1.Objects ?= $$(strip $$($1.ObjectsC) $$($1.ObjectsCxx) $$($1.ObjectsObjC))

# Suggested linger depends on the cardinality of variou types of objects.
$1.SuggestedLinkerSymbol ?= $$(if $$($1.ObjectsObjC),OBJCLD,$$(if $$($1.ObjectsCxx),CXXLD,CCLD))

# Check if we have the required compiler.
$$(if $$(or $$($1.ObjectsC),$$($1.ObjectsObjC)),$$(if $$(Toolchain.CC.IsAvailable),,$$(error Building $1 requires a C compiler)))
$$(if $$($1.ObjectsCxx),$$(if $$(Toolchain.CXX.IsAvailable),,$$(error Building $1 requires a C++ compiler)))

# This is how to compile each specific source file.
$$(foreach src,$$($1.sourcesC),$$(eval $$(call ObjectGroup.COMPILE.c,$1,$$(src))))
$$(foreach src,$$($1.sourcesCxx),$$(eval $$(call ObjectGroup.COMPILE.cc,$1,$$(src))))
$$(foreach src,$$($1.sourcesObjC),$$(eval $$(call ObjectGroup.COMPILE.m,$1,$$(src))))
# Create all support directories for out-of-tree builds
$$(foreach d,$$(patsubst %/,%,$$(addprefix $$(CURDIR)/,$$(filter-out ./,$$(sort $$(dir $$($1.sources)))))),$$(eval $$(call ZMK.Expand,Directory,$$d)))

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
