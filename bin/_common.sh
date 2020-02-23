#!/usr/bin/env bash
#/*
 #* Copyright 2014-2020 the original author or authors.
 #*
 #* Licensed under the Apache License, Version 2.0 (the "License");
 #* you may not use this file except in compliance with the License.
 #* You may obtain a copy of the License at
 #*
 #*     http://www.apache.org/licenses/LICENSE-2.0
 #*
 #* Unless required by applicable law or agreed to in writing, software
 #* distributed under the License is distributed on an "AS IS" BASIS,
 #* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #* See the License for the specific language governing permissions and
 #* limitations under the License.
 #*/
 
$(dirname $0)/_vars.sh
$(dirname $0)/_logging.sh

WORKING_DIRECTORY=$(cd $(dirname $0); pwd)

# keep a cache directory of projects that we are using so we dont keep having to do fresh checkouts
CACHE_DIRECTORY="${WORKING_DIRECTORY}/cache"

if [ ! -d "${CACHE_DIRECTORY}" ]; then
  mkdir "${CACHE_DIRECTORY}"
fi

function require {
    command -v $1 > /dev/null 2>&1 || {
        echo "❌       Dude!!! Some of the required software is not installed:"
        echo "        please install $1" >&2;
        exit 1;
    }
}

function createTempDirectory {
    NAME="$(date "+%Y%m%d%H%M%S")"
    TMP_DIR="${WORKING_DIRECTORY}/${NAME}"
    rm -rdf "${TMP_DIR}"
    mkdir "${TMP_DIR}"
    echo "${TMP_DIR}"
}

function cleanUpTempDirectory {
    cd "${WORKING_DIRECTORY}"
    rm -rdf "${TMP_DIR}"
}
 
# Using jq to extract json node data from the jsonfile
# usage 
#   $1 = filename
#   $2 = query
#   $3 = default value
function getJsonItem {
 
    # -r option removes "
    local ITEM_TO_FIND="$(cat $1 | jq -r $2)"

    if [[ $ITEM_TO_FIND == "null" ]]
    then
      echo $3
      return 1
    else
      echo ${ITEM_TO_FIND}
      return 0
    fi

}

# Using jq to extract multiple json node data from the jsonfile
# usage 
#   $1 = filename
#   $2 = query
#   $3 = index item
function getJsonIndexItemByName {

    # -r option removes "
    local cmd="jq -r '$2 | .[].$3' $1"
  
    local found=$(eval "cat $1 | $cmd")
 
    echo ${found}

    if [ -z "${found}" ]
    then
        return 1
    fi

    return 0
}

# usage: arg_or_default arg default [new arg value]
arg_or_default() {
  if [[ -n "$1" ]]; then
    if [[ "$#" -eq 3 ]]; then
      echo "$3"
    else
      echo "$1"
    fi
  else
    echo "$2"
  fi
}

# This wonderful function should be called thus:
# string_replace "replacement string" "$placeholder_string" variable_name
#
#template='docker start %s xxxx'
#server='-d myimage'
#string_replace "$server" "$template" destination_variable
#echo "$destination_variable"
string_replace() {
    printf -v $3 "$2" "$1"
}

get_array_items() {

    local data=$(getJsonItem $1 $2 "[]")
   
    #sample='[{"name":"foo"},{"name":"bar"}]'
    for row in $(echo "${data}" | jq -r '.[] | @base64'); do
        _jq() {
          echo ${row} | base64 --decode | jq -r ${1}
        }

        echo "$(_jq $3)"
    done
}
