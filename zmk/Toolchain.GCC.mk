# Are we using GCC?
Toolchain.CC.IsGcc=$(if $(findstring gcc,$(Toolchain.cc)),yes)
Toolchain.CXX.IsGcc=$(if $(findstring g++,$(Toolchain.cxx)),yes)

# Logic specific to gcc
ifneq (,$(Toolchain.CC.IsGcc))

# If we are configured then check for cross compilation by mismatch
# of host and build triplets. When this happens set CC.
# This is important for autoconf/automake compatibility.
ifneq (,$(and $(Configure.Configured),$(Configure.HostArchTriplet),$(Configure.BuildArchTriplet)))
ifneq ($(Configure.BuildArchTriplet),$(Configure.HostArchTriplet))
CC = $(Configure.HostArchTriplet)-gcc
$(if $(Toolchain.debug),$(info DEBUG: gcc cross-compiler selected CC=$(CC)))
endif # !cross-compiling
endif # !configured

# Indirection for testability
Toolchain.cc.dumpmachine  ?= $(shell $(CC)  -dumpmachine)
Toolchain.gcc.dumpmachine ?= $(shell gcc    -dumpmachine)
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.cc.dumpmachine=$(Toolchain.cc.dumpmachine)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.gcc.dumpmachine=$(Toolchain.gcc.dumpmachine)))

# Are we targeting Windows with mingw?
ifneq (,$(findstring mingw,$(Toolchain.cc.dumpmachine)))
exe = .exe
Toolchain.CC.ImageFormat = PE
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) -dumpmachine mentions mingw))
endif # !mingw

# Are we targeting Linux?
ifneq (,$(findstring linux,$(Toolchain.cc.dumpmachine)))
Toolchain.CC.ImageFormat = ELF
endif # !linux

# Is gcc cross-compiling?
ifneq ($(Toolchain.gcc.dumpmachine),$(Toolchain.cc.dumpmachine))
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because gcc -dumpmachine and $(CC) -dumpmachine differ))
endif # !cross
endif # !cc=gcc


# Logic specific to g++
ifneq (,$(Toolchain.CXX.IsGcc))

# If we are configured then check for cross compilation by mismatch
# of host and build triplets. When this happens set CXX.
# This is important for autoconf/automake compatibility.
ifneq (,$(and $(Configure.Configured),$(Configure.HostArchTriplet),$(Configure.BuildArchTriplet)))
ifneq ($(Configure.BuildArchTriplet),$(Configure.HostArchTriplet))
CXX = $(Configure.HostArchTriplet)-g++
$(if $(Toolchain.debug),$(info DEBUG: g++ cross-compiler selected CXX=$(CXX)))
endif # !cross-compiling
endif # !configured

# Indirection for testability
Toolchain.cxx.dumpmachine ?= $(shell $(CXX) -dumpmachine)
Toolchain.g++.dumpmachine ?= $(shell g++    -dumpmachine)
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.cxx.dumpmachine=$(Toolchain.cxx.dumpmachine)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.g++.dumpmachine=$(Toolchain.g++.dumpmachine)))

# Are we targeting Windows with mingw?
ifneq (,$(findstring mingw,$(Toolchain.cxx.dumpmachine)))
exe = .exe
Toolchain.CXX.ImageFormat = PE
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) -dumpmachine mentions mingw))
endif # !mingw

# Are we targeting Linux?
ifneq (,$(findstring linux,$(Toolchain.cxx.dumpmachine)))
Toolchain.CXX.ImageFormat = ELF
endif # !linux

# Is g++ cross compiling?
ifneq ($(Toolchain.g++.dumpmachine),$(Toolchain.cxx.dumpmachine))
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because g++ -dumpmachine and $(CXX) -dumpmachine differ))
endif # !cross
endif # !cxx=gcc


# If dependency tracking is enabled, pass extra options to the compiler, to
# generate dependency data at the same time as compiling object files.
ifneq (,$(Toolchain.DependencyTracking))
CPPFLAGS += -MMD
$(if $(Toolchain.debug),$(info DEBUG: compiling object files will generate make dependency information))
-include *.d
endif


$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CC.IsGcc=$(Toolchain.CC.IsGcc)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CXX.IsGcc=$(Toolchain.CXX.IsGcc)))
