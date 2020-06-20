# Are we using Clang?
Toolchain.CC.IsClang=$(if $(findstring clang,$(Toolchain.cc)),yes)
Toolchain.CXX.IsClang=$(if $(findstring clang,$(Toolchain.cxx)),yes)
Toolchain.IsClang=$(and $(Toolchain.CC.IsClang),$(Toolchain.CXX.IsClang))

$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CC.IsClang=$(Toolchain.CC.IsClang)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CXX.IsClang=$(Toolchain.CXX.IsClang)))
$(if $(Toolchain.debug),$(info DEBUG: Toolchain.IsClang=$(Toolchain.IsClang)))