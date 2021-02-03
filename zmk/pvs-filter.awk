# Copyright 2019-2021 Zygmunt Krynicki.
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

# Awk script for taming the output of plog-converter.
# Requires $srcdir and $abssrcdir environment variables.

BEGIN {
	FAILED=0;
	SRCDIR=ENVIRON["srcdir"];
	NSKIP=length(ENVIRON["abssrcdir"]);
	# print(sprintf("nskip %d", NSKIP));
}

# Skip the annoying URL notice.
/^www\.viva64\.com\/en\/w:1:1/ { next }

# We know this is an open source project.
/^.*: error: V1042 .*$/ { next }

# Pick up warnings and errors. Use relative file names.
# The +1 below is because awk uses 1-based indexing.
/^.*: (warning|error):/ {
	FAILED=1;
	# print($0);
	print(sprintf("%s%s", SRCDIR, substr($0, NSKIP + 2)));
}

# Exit if warnings or errors were reported.
END { if (FAILED) exit(1); }
