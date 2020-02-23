#!/bin/bash

# This wonderful function should be called thus:
# string_replace "replacement string" "$placeholder_string" variable_name
string_replace() {
    printf -v $3 "$2" "$1"
}

# How to use it:
template="my%sappserver"
server="whatever-you-like"

string_replace "$server" "$template" destination_variable

echo "$destination_variable"

template='docker start %s xxxx'
server='-d myimage'
string_replace "$server" "$template" destination_variable

echo "$destination_variable"