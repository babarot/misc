#!/usr/bin/awk -f

########################### AWK CSV Parser ###########################
#                                                                    #
#      ********** This file is in the public domain. **********      #
#                                                                    #
# Use this source in any way you wish.                               #
# Feedback and bug reports would be appreciated.                     #
# As would a note about what how you are using it.                   #
#                                                                    #
# For more information email LoranceStinson+csv@gmail.com.           #
# Or see http://lorance.freeshell.org/csv/                           #
#                                                                    #
######################################################################

# csv_parse(string,csv,sep,quote,escape,newline,trim)
# Parse a CSV string into an array.
# The number of fields found is returned.
# In the event of an error a negative value is returned. (See below.)
# Use csv_err() to convert the error number to an error string.
#
# Parameters:
# string  = The string to parse.
# csv     = The array to parse the fields into.
#           The array is not cleared prior to parsing.
# sep     = The field separator character. Normally ,
# quote   = The string quote character. Normally "
# escape  = The quote escape character. Normally "
# newline = Handle embedded newlines. Provide either a newline or the
#           string to use in place of a newline. If left empty embedded
#           newlines cause an error. If set to -1 then error -1 is returned
#           when a new line is expected. This is to allow the caller to handle
#           getting the required extra data.
# trim    = When true spaces around the separator are removed.
#           This affects parsing. Without this a space between the
#           separator and quote result in the quote being ignored.
#
# Private variables:
# fields  = The number of fields found thus far.
# pos     = Where to pull a field from the string.
# strtrim = Used for triming whitespace and identifying when a quoted field is
#           found so the quotes are removed.
#
# Error conditions:
# -1  = More data expected.
# -2  = Unable to read the next line.
# -3  = Missing end quote.
# -4  = Missing separator.
#
# Notes:
# The code assumes that every field is preceded by a separator, even the
# first field. This makes the logic much simpler, but also requires a
# separator be prepended to the string before parsing.
function csv_parse(string,csv,sep,quote,escape,newline,trim, fields,pos,strtrim) {
    # Make sure there is something to parse.
    if (length(string) == 0) return 0
    # Initial setup.
    string = sep string # The code below assumes ,FIELD.
    fields = 0          # The number of fields found thus far.
    # The main parsing loop.
    while (length(string) > 0) {
        # Remove spaces after the separator if requested.
        if (trim && substr(string, 2, 1) == " ") {
            if (length(string) == 1) return fields
            string = substr(string, 2)
            continue
        }

        strtrim = 0 # Used to trim quotes off strings.
        # Handle a quoted field.
        if (substr(string, 2, 1) == quote) {
            pos = 2
            do {
                pos++
                if (pos != length(string) &&
                    substr(string, pos, 1) == escape &&
                    index(quote escape, substr(string, pos + 1, 1)) != 0) {
                    # Remove escaped quote and escape characters.
                    string = substr(string, 1, pos - 1) substr(string, pos + 1)
                } else if (substr(string, pos, 1) == quote) {
                    # Found the end of the string.
                    strtrim = 1
                } else if (pos >= length(string)) {
                    # Handle embedded newlines if requested.
                    if (newline == -1) {
                        return -1
                    } else if (newline) {
                        if (getline == -1) return -4
                        string = string newline $0
                    }
                }
            } while (pos < length(string) && strtrim == 0)
            # Make sure the end of the string is found.
            if (strtrim == 0) {
                return -3
            }
        } else {
            # Handle an empty field.
            if (length(string) == 1 || substr(string, 2, 1) == sep) {
                fields++
                csv[fields] = ""
                if (length(string) == 1) return fields
                string = substr(string, 2)
                continue
            }
            # Search for a separator.
            pos = index(substr(string, 2), sep)
            # If there is no separator the rest of the string is a field.
            if (pos == 0) {
                fields++
                csv[fields] = substr(string, 2)
                return fields
            }
        }
        # Remove spaces after the separator if requested.
        if (trim && pos != (length(string) + strtrim) && substr(string, pos + strtrim, 1) == " ") {
            trim = strtrim
            # Count the number fo spaces found.
            while (pos < length(string) && substr(string, pos + trim, 1) == " ") {
                trim++
            }
            # Remove them from the string.
            string = substr(string, 1, pos + strtrim - 1) substr(string,  pos + trim)
            # Adjust pos with the trimmed spaces if a quotes string was not found.
            if (!strtrim) {
                pos -= trim
            }
        }
        # Make sure we are at the end of the string or there is a separator.
        if ((pos != length(string) && substr(string, pos + 1, 1) != sep)) {
            return -4
        }
        # Gather the field.
        fields++
        csv[fields] = substr(string, 2 + strtrim, pos - (1 + strtrim * 2))
        # Remove the field from the string for the next pass.
        if (pos == length(string)) {
            return fields
        } else {
            string = substr(string, pos + 1)
        }
    }
    return fields
}

# csv_create (csv,fields,sep,quote,escape,level)
# Creates a CSV string from an array.
# Returns the new CSV string.
#
# Parameters:
# csv     = The array of data to turn into a string.
#           Expects fields to start counting from 1.
# fields  = The number of fields to work with.
# sep     = The field separator character. Normally ,
# quote   = The string quote character. Normally "
# escape  = The quote escape character. Normally "
# level   = Quote level for output. Defaults to 0.
#          -1 = Do not quote or escape any fields.
#           0 = Only fields that require it are quoted.
#           1 = All non-number fields are quoted. /^-*[0-9.][0-9.]*$/
#           2 = All fields are quoted except empty ones.
#           3 = All fields are quoted including empty ones.
#
# Private variables:
# field   = The field currently being worked on.
# pos     = The position in the field being worked on.
# string  = The CSV string.
function csv_create (csv,fields,sep,quote,escape,level, field,pos,string) {
    # Set defaults for the parameters.
    sep     = (sep ? sep : ",")
    quote   = (quote ? quote : "\"")
    escape  = (escape ? escape : "\"")
    level   = (level ? level : 0)

    # Initialize the string.
    string = ""

    # Process the fields.
    for (pos = 1; pos <= fields; pos++) {
        # Get the field for easier processing.
        field = csv[pos]
        if (field) {
            # Try to determine if the string needs to be quoted.
            if (level == 0) {
                # Escape the string, if required.
                string = string csv_escape_string(field, quote, escape, quote escape)
            } else if ((level >= 2) ||
                       (level == 1 && field !~ /^-*[0-9.][0-9.]*$/)) {
                # Quote and escape the string.
                string = string quote csv_escape_string(field, "", escape, quote escape) quote
            } else {
                # Add the field as is. (Levels -1, 1 & number)
                string = string field
            }
        } else if (level == 3) {
            # Quote the empty field.
            string = string quote quote
        }
        # Add a separator unless this is the last field.
        if (pos < fields) string = string sep
        #if (pos < fields) print "a"
    }

    # Return the CSV string.
    return string
}

# csv_err (number)
# Turns a CSV error into a string.
# Returns the new error string.
#
# Parameters:
# number  = The error number to convert.
function csv_err (number) {
    if (number == -1) {
        return "More data expected."
    } else if (number == -2) {
        return "Unable to read the next line."
    } else if (number == -3) {
        return "Missing end quote."
    } else if (number == -4) {
        return "Missing separator."
    }
}

# csv_escape_string (string,quote,escape,special, pos,char,csv)
# Escapes a CSV string.
# Returns the new CSV string.
#
# Parameters:
# string  = The string to escape.
# quote   = The quote character. Normally ".
# escape  = The escape character. Normally " or \.
# special = Special characters to escape.
#
# Private variables:
# pos     = The position in the string.
# prev    = The previous position in the string.
# char    = the current character being worked on.
# csv     = The CSV string.
#
# Notes:
# This function is intended only for csv_create().
# The string is only quoted if characters are escaped and quote is non-empty.
function csv_escape_string (string,quote,escape,special, pos,prev,char,csv) {
    # Start at the beginning of the string.
    prev = 1
    csv = ""

    # Check each character of the string, escaping if necessary.
    for (pos = 1; pos < length(string) + 1; pos++) {
        char = substr(string, pos, 1)
        # Check for a special character.
        if (index(special, char) > 0) {
            if (pos == 1) {
                csv = escape char
            } else {
                csv = csv substr(string, prev, (pos - prev)) escape char
            }
            prev = pos + 1
        }
    }

    # Add the rest of the string, if it was not all used.
    if (prev != pos) {
        csv = csv substr(string, prev)
    }

    # Return the escaped string.
    if (quote && string != csv) {
        return quote csv quote
    } else {
        return csv
    }
}

{
    #print "-------"
    num_fields = csv_parse($0, csv, ",", "\"", "\"", "\\n", 1)
    #print num_fields
    #if (num_fields < 0) {
    #    printf "ERROR: %d (%s) -> %s\n", num_fields, csv_err(num_fields), $0
    #}
    #for (i = 1; i <= num_fields; i++) {
    #    printf "| %s ", csv[i];
    #}
    #printf " |\n";
}
