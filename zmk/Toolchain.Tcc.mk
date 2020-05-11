# Is CC the tcc compiler?
Toolchain.CC.IsTcc=$(if $(findstring tcc,$(Toolchain.cc)),yes)

$(if $(Toolchain.debug),$(info DEBUG: Toolchain.CC.IsTcc=$(Toolchain.CC.IsTcc)))
