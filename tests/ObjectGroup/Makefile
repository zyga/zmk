include z.mk

group1.Sources = main.c
$(eval $(call ZMK.Expand,ObjectGroup,group1))
group2.Sources = main.cpp
$(eval $(call ZMK.Expand,ObjectGroup,group2))
group3.Sources = main.m
$(eval $(call ZMK.Expand,ObjectGroup,group3))
# Alternative C++ extensions
group4.Sources = main.cxx
$(eval $(call ZMK.Expand,ObjectGroup,group4))
group5.Sources = main.cc
$(eval $(call ZMK.Expand,ObjectGroup,group5))
# Source code can be in arbitrary tree structure.
group6.Sources = src/main.c
$(eval $(call ZMK.Expand,ObjectGroup,group6))

.PHONY: build
build: group1-main.o group2-main.o group3-main.o group4-main.o group5-main.o src/group6-main.o
