#! /bin/bash

filename="ipaddr: 45354534 ipreplace 1224"

echo "After Replacement:" ${filename/ipreplace/19.1.6.5.6}

with="197.2.45.3"

filename="ipaddr: 45354534 ipreplace 1224"

echo "After Replacement:" ${filename/ipreplace/$with}

#${filename/str*./operations.}

#after=${filename/ipaddr*#/$with ''}

#echo "After Replacement: $after"


filename="bash.string.txt"

echo "After Replacement:" ${filename/string/operationsxxxx}
