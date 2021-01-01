# Are we using Clang?
Toolchain.CC.IsClang?=$(if $(or $(findstring clang,$(Toolchain.cc)),$(findstring clang,$(Toolchain.cc.version))),yes)
Toolchain.CXX.IsClang?=$(if $(or $(findstring clang,$(Toolchain.cxx)),$(findstring clang,$(Toolchain.cxx.version))),yes)
Toolchain.IsClang?=$(and $(Toolchain.CC.IsClang),$(Toolchain.CXX.IsClang))
# TODO: handle cross compiling with clang.
