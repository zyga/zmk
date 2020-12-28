include z.mk

prog1.Sources = main.c
$(eval $(call ZMK.Expand,Program,prog1))
prog2.Sources = main.cpp
$(eval $(call ZMK.Expand,Program,prog2))
prog3.Sources = main.m
$(eval $(call ZMK.Expand,Program,prog3))
# Alternative C++ extensions
prog4.Sources = main.cxx
$(eval $(call ZMK.Expand,Program,prog4))
prog5.Sources = main.cc
$(eval $(call ZMK.Expand,Program,prog5))
# Source code can be in arbitrary tree structure.
prog6.Sources = src/main.c
$(eval $(call ZMK.Expand,Program,prog6))
