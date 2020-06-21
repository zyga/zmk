# Is CC the tcc compiler?
Toolchain.CC.IsTcc=$(if $(findstring tcc,$(Toolchain.cc)),yes)