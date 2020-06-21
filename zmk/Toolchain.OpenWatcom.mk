# Are we using the open watcom compiler?
Toolchain.CC.IsWatcom=$(if $(findstring watcom,$(Toolchain.cc)),yes)
Toolchain.CXX.IsWatcom=$(if $(findstring watcom,$(Toolchain.cxx)),yes)
Toolchain.IsWatcom=$(and $(Toolchain.CC.IsWatcom),$(Toolchain.CXX.IsWatcom))

# Logic specific to open-watcom
ifneq (,$(Toolchain.CC.IsWatcom))

# Are we building for DOS or 16bit Windows?
ifneq (,$(or $(findstring dos,$(Toolchain.cc)),$(findstring win16,$(Toolchain.cc))))
exe = .exe
Toolchain.CC.ImageFormat = MZ
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because open-watcom targets DOS))
endif # !cc win16 || dos

# Are we building for 32bit Windows?
ifneq (,$(findstring win32,$(Toolchain.cc)))
exe = .exe
Toolchain.CC.ImageFormat = PE
Toolchain.CC.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CC) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because open-watcom targets Windows))
endif # !cc win32
endif # !cc watcom

# Logic specific to open-watcom
ifneq (,$(Toolchain.CXX.IsWatcom))

# Are we building for DOS or 16bit Windows?
ifneq (,$(or $(findstring dos,$(Toolchain.cxx)),$(findstring win16,$(Toolchain.cxx))))
exe = .exe
Toolchain.CXX.ImageFormat = MZ
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because open-watcom targets DOS))
endif # !cxx win16 || dos

# Are we building for 32bit Windows?
ifneq (,$(findstring win32,$(Toolchain.cxx)))
exe = .exe
Toolchain.CXX.ImageFormat = PE
Toolchain.CXX.IsCross = yes
$(if $(Toolchain.debug),$(info DEBUG: .exe suffix enabled because $(CXX) name))
$(if $(Toolchain.debug),$(info DEBUG: cross-compiling because open-watcom targets Windows))
endif # !cxx win32
endif # !cxx watcom
