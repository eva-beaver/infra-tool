#!/usr/bin/env bash
full_string="I love Suzy and Mary Suzy"
search_string="Suzy"
replace_string="Sara"

my_string1=${full_string//[a-z]/$search_string/$replace_string}


my_string2=${full_string//[a-z]/Suzy/Sarah}

echo $my_string1
echo $my_string2


