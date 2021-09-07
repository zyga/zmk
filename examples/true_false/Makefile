# SPDX-FileCopyrightText: 2019-2024 Zygmunt Krynicki
# SPDX-License-Identifier: LGPL-3.0-only
#
# This file is part of zmk.
#
# Zmk is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3 as
# published by the Free Software Foundation.
#
# Zmk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Zmk.  If not, see <https://www.gnu.org/licenses/>.

include z.mk                                            # Include the zmk library

true.Sources = true_false.c                             # Define the source files to compile into true
$(eval $(call ZMK.Expand,Program,true))                 # Expand template for programs with the name true
true$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_SUCCESS        # Pass macro definition when compiling true

false.Sources = true_false.c                            # Define the source files to compile into false
$(eval $(call ZMK.Expand,Program,false))                # Expand template for programs with the name false
false$(exe): CPPFLAGS += -DEXIT_CODE=EXIT_FAILURE       # Pass macro definition when compiling false
