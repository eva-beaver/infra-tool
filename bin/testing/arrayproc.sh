#!/bin/bash

makeJunk()
{
   echo 'this is junk'
   echo '#more junk and "b@d" characters!'
   echo '!#$^%^&(*)_^&% ^$#@:"<>?/.,\\"'"'"
   echo $"         - xxxxxxx"
}

processJunk()
{
    local -a arr=()    
    local -a arr1=()    
    # read each input and add it to arr
    while read -r line
    do 
       arr[${#arr[@]}]='"'"$line"'" is junk'; 
       arr1[${#arr1[@]}]='"'"$line"'" is junk'; 
       #echo "$arr1[0]"
    done;

    # output the array as a string in the "declare" representation
    declare -p arr | sed -e 's/^declare -a [^=]*=//'
}

# processJunk returns the array in a flattened string ready for "declare"
# Note that because of the pipe processJunk cannot return anything using
# a global variable
returned_string=`makeJunk | processJunk`

# convert the returned string to an array named returned_array
# declare correctly manages spaces and bad characters
eval "declare -a returned_array=${returned_string}"

for junk in "${returned_array[@]}"
do
   echo "$junk"
done