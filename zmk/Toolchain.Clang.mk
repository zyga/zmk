# Are we using Clang?
Toolchain.CC.IsClang=$(if $(findstring clang,$(Toolchain.cc)),yes)
Toolchain.CXX.IsClang=$(if $(findstring clang,$(Toolchain.cxx)),yes)

# If dependency tracking is enabled, pass extra options to the compiler, to
# generate dependency data at the same time as compiling object files.
ifneq (,$(Toolchain.DependencyTracking))
CPPFLAGS += -MMD
$(if $(Toolchain.debug),$(info DEBUG: compiling object files will generate make dependency information))
-include *.d
endif

$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CC.IsClang=$(Toolchain.CC.IsClang)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CXX.IsClang=$(Toolchain.CXX.IsClang)))