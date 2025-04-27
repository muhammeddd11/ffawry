1.  A breakdown of how your script handles arguments and options?

First, i define default values: line_nums=0, inverse=0, pattern="", and file="" then i loop over all arguments with while [ $# -gt 0 ]; do .... ,inside that loop, i use a case statement:

--help triggers the usage function and exits.
-n sets line_nums=1, meaning it will print line numbers.
-v sets inverse=1, meaning it will flip match logic (show lines that don't match).
-nv or -vn sets both line_nums and inverse flags at once.
Any other -\* flags are considered invalid and i throw a fun error ("WTF is $1?").

Otherwise, if it's not an option, i check:

If pattern is empty, i assign it.
If file is empty, i assign it.
If both are already assigned and more arguments come, i throw a "too many arguments" error.

After parsing: i check if a pattern was given, and make sure it's not just whitespace then i check if a file was provided and whether it exists, otherwise i default to reading from stdin.

2- A short paragraph: If you were to support regex or -i/-c/-l options, how would your structure change?

To support regex i would need to probably replace the match part with something that works with regex provided for -i (case insensitive), i wouldn't need shopt -s nocasematch anymore; instead, forcing both the pattern and the line to lowercase before matching.for -c (count), i'd need to add a counter and, instead of printing matching lines, just print the final count after processing for -l it would only make sense when dealing with multiple files, so i'd have to restructure how i handle inputs — currently, my script assumes only one file max bottom line

3- What part of the script was hardest to implement and why?

the hardest part is managing the matching and the inverse logic cleanly without getting tangled especially because i first check if a line matches, then immediately flip it if inverse=1 it’s easy to mess this up
