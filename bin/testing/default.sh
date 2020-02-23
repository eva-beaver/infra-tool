#!/usr/bin/env bash

# Using jq to extract json node data from the jsonfile
# usage 
#   $1 = filename
#   $2 = query
function getJsonItem {
 
    # -r option removes "
    ITEM_TO_FIND="$(cat $1 | jq -r $2)"

    echo ${ITEM_TO_FIND}

    if [ -z "${ITEM_TO_FIND}" ]
    then
        return 1
    fi

    return 0
}

    MANIFEST_NAME="manifest.json"

    rslt=$(getJsonItem $MANIFEST_NAME '.run.commandx')

    echo rslt

    echo "$(cat $MANIFEST_NAME | jq -r '.run.commandx')"

    rslt="$(cat $MANIFEST_NAME | jq -r '.run.commandx')"

    echo $rslt

    if [[ $rslt == "null" ]]
    then
       echo "Not found"
    else
       echo $rslt
    fi
