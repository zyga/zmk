# Are we using Clang?
Toolchain.CC.IsClang=$(if $(findstring clang,$(Toolchain.cc)),yes)
Toolchain.CXX.IsClang=$(if $(findstring clang,$(Toolchain.cxx)),yes)
Toolchain.IsClang=$(and $(Toolchain.CC.IsClang),$(Toolchain.CXX.IsClang))
# TODO: handle cross compiling with clang.
