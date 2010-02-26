#
# APP the AWK preprocessor
#
# Supports #define, #undef, #ifdef, #ifndef, #else, #endif
#
# Use #define SILENT_FILE to prevent from printing anything.
# This #define gets cleared at the start of each file.
#
# Copyright Přemysl Janouch 2010. All rights reserved.
# See the file LICENSE for licensing information.
#
#

BEGIN {
	process = 1
}

# Clear the SILENT_FILE flag at the first line.
FNR == 1 {
	delete defs["SILENT_FILE"]
}

# Define a variable
process && /^[ \t]*#define [^ \t]+/ {
	defs[$2] = 1
	next
}

# Undefine a variable
process && /^[ \t]*#undef [^ \t]+/ {
	delete defs[$2]
	next
}

# Process if variable defined
/^[ \t]*#ifdef [^ \t]+/ {
	if (process)
		process = $2 in defs
	else
		level++
	next
}

# Process if variable not defined
/^[ \t]*#ifndef [^ \t]+/ {
	if (process)
		process = !($2 in defs)
	else
		level++
	next
}

# Invert the condition effects
/^[ \t]*#else/ {
	if (!level)
		process = !process
	next
}

# End a condition
/^[ \t]*#endif/ {
	if (!level)
		process = 1
	else
		level--
	next
}

# If we may, print the line
process && !("SILENT_FILE" in defs)

