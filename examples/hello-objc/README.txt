Notes about Objective C. Unlike C and C++, objective C is differs across
platforms. MacOS has support for Objective C 2.0 from Apple while Linux and
other similar operating systems get Objective C 1.x and the GNU Step
implementation of the Foundation libraries. As such, instead of trying to be
clever, be practical and allow the author specify exactly what they need
manually.

Practical applications will most likely add to CFLAGS the following:

	-framework Foundation: for headless MacOS programs
	-framework Cocoa: for the graphical MacOS programs
	$(shell gnustep-config --base-libs): for headless Linux programs
	$(shell gnustep-config --gui-libs): for the rare GNU Step GUI program

Note that CFLAGS are used as a compromise across MacOS make, stuck at an old
version before GPL-3 and Linux make, which is up-to-date.
