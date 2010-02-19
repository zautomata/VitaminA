#
# VitaminA GAWK utilities
#
# Copyright Přemysl Janouch 2010. All rights reserved.
# See the file LICENSE for licensing information.
#
#

# Retrieve configuration (for plugins)
# Input:
#   key:    Key for the configuration value
function getconfig (key)
{
	print "VITAMINA getconfig :" key
	getline key
	return key
}

# Print a string (for plugins)
function botprint (string)
{
	print "VITAMINA print :" string
}

# IRC message parsing
# Input:
#   line:   The message to be parsed
# Output:
#   mwho:   Message origin
#   mcmd:   Command name
#   mparam: Command parameters
#
function parse (line,     s, n, id, token)
{
	s = 1
	id = 0

	mwho = ""
	mcmd = ""
	delete mparam

	n = match(substr(line, s), / |$/)
	while (n)
	{
		token = substr(line, s, n - 1)
		if (token ~ /^:/)
		{
			if (s == 1)
				mwho = substr(token, 2)
			else
			{
				mparam[id] = substr(line, s + 1)
				break
			}
		}
		else if (!mcmd)
			mcmd = toupper(token)
		else
			mparam[id++] = token

		s = s + n
		n = index(substr(line, s), " ")

		if (!n)
		{
		       n = length(substr(line, s)) + 1
		       if (n == 1)
			       break;
		}
	}

#	print ("mwho = " mwho)
#	print ("mcmd = " mcmd)
#	for (id in mparam)
#		print ("mparam[" id "] = " mparam[id])
#	print ("")
}

