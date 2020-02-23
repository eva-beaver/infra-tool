#!/bin/bash

function Dictionary_Builder() {
    declare -A dict=(['title']="Title of the song"
                 ['artist']="Artist of the song"
                 ['album']="Album of the song",
                 ['tracks']="12"
                )

    echo '('
    for key in  "${!dict[@]}" ; do
        echo "['$key']='${dict[$key]}'"
    done
    echo ')'
}

declare -A Output_Dictionary="$(Dictionary_Builder)"

alb='album'

for key in  "${!Output_Dictionary[@]}" ; do
    echo "${key}: '"${Output_Dictionary[$key]}"'"
done

    echo "${Output_Dictionary[$alb]}"
