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
 
. $(dirname $0)/_common.sh
. $(dirname $0)/_vars.sh

function _buildDockerComposeFileV2 {

    echo "🔩       Generating  docker-compose file for $MANIFEST_TYPE_INFO_NAME-$MANIFEST_VERSION"

    printf '%s\n' "# Generated $(date) from version $MANIFEST_TYPE_INFO_NAME-$MANIFEST_VERSION" \
        "version: \"$MANIFEST_TYPE_DOCKERCOMPOSE_VERSION\"" \
        >docker-compose.yml

    _buildNetworkSection

    printf '%s\n' "# Generated Services" \
        "services:" \
        >>docker-compose.yml

    _buildRequiresSectionsV2

    _buildVolumesSectionV2

    if (( $MANIFEST_TYPE_DOCKERCOMPOSE_STARTAFTERBUILD == 1 ));then
        echo "🔩       Running docker compose"
        docker-compose up -d --remove-orphans
    fi

}

function _buildNetworkSection {

    printf '%s\n' '# Generated networks' \
        'networks:' \
        "  $MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME:" \
        "    driver: $MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKTYPE" \
        "    ipam:" \
        "      config:" \
        "        - subnet: $MANIFEST_TYPE_DOCKERCOMPOSE_IPMASK" \
        >>docker-compose.yml

}

function _buildRequiresSectionsV2 {

    for index in "${!ARR_REQUIRE_NAME[@]}"
    do

        # check if template file exists
        if test -f "$SCRIPT_DIR/docker-templates/${ARR_REQUIRE_NAME[index]}/${ARR_REQUIRE_TEMPLATE[index]}"; then
            echo "🔩       Generating    ${ARR_REQUIRE_NAME[index]} - ${ARR_REQUIRE_TEMPLATE[index]}"
        else    
            echo "❌       build failure - ${ARR_REQUIRE_NAME[index]} - ${ARR_REQUIRE_TEMPLATE[index]} does not exist!!!!"; exit 1
        fi


        if [ "${ARR_REQUIRE_REQUIRED[index]}" -eq 1 ];then

            IFS=$'\n' read -d '' -r -a lines < $SCRIPT_DIR/docker-templates/${ARR_REQUIRE_NAME[index]}/${ARR_REQUIRE_TEMPLATE[index]}
            
            for line in "${lines[@]}"
            do

                local ignore=0

                # if we have an envirmont section then add environment details from docker section
                if [[ $line = *envReplace:* ]]
                then

                    printf '%s\n' "    environment:" \
                        >>docker-compose.yml

                    # Add environment variables for Java
                    for i in ${!MANIFEST_TYPE_DOCKER_ENVOPT_NAME[@]}; do
                        local javaEnv="${MANIFEST_TYPE_DOCKER_ENVOPT_NAME[i]}: ${MANIFEST_TYPE_DOCKER_ENVOPT_VALUE[i]}" 
                        #echo $javaEnv
                        printf '%s\n' "      $javaEnv" \
                            >>docker-compose.yml
                    done

                    if [ -n "$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES" ];then
                        local javaEnv=$"SPRING_PROFILES_ACTIVE: $MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES"
                        printf '%s\n' "      $javaEnv" \
                            >>docker-compose.yml
                    fi
                
                    ignore=1

                fi

                if [[ $line = *portsReplace:* ]]
                then

                    printf '%s\n' "    ports:" \
                        >>docker-compose.yml

                    for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
                    do
                        printf '%s\n' \
                            "      - $ports" \
                            >>docker-compose.yml
                    done
                
                    ignore=1

                fi

                if (( $ignore == 0 ))
                then
                    #echo -e $line
                    #local output=$(_replaceMarkers $line)
                    #string_replace "$SCRIPT_DIR" "$line" output
                    local output=${line/scptdirreplace/$SCRIPT_DIR}
                    local output=${output/ipreplace/${ARR_REQUIRE_IPADDR[index]}}
                    local output=${output/nwnamereplace1/$MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME}
                    local output=${output/baseImagePrefix/$MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX}
                    local output=${output/containerName/$MANIFEST_TYPE_DOCKER_CONTAINERNAME}
                    local output=${output/containerVersion/$MANIFEST_TYPE_DOCKER_VERSION}
                    #echo -e "$output"
                    printf '%s\n' "$output" \
                        >>docker-compose.yml
            fi
            done

            echo "🔩       Generated ${ARR_REQUIRE_NAME[index]}"

        else
            echo "🔩       ${ARR_REQUIRE_NAME[index]} not required"
        fi

    done

}

function _buildVolumesSectionV2 {

    # Extract all the volumes require
    local arr_volName=(`echo "$(__get_array_items_from_array  $MANIFEST_NAME '.volName')"`);
    local arr_volDriver=(`echo "$(__get_array_items_from_array  $MANIFEST_NAME '.volDriver')"`);
    local arr_volCreate=(`echo "$(__get_array_items_from_array  $MANIFEST_NAME '.volCreate')"`);
 
    #echo ${#arr_volName[@]}

    local volCnt=0
    for index in "${!arr_volName[@]}"
    do

        if (( ${arr_volCreate[index]} == 1 ));then
            let volCnt++
        fi

    done

    #echo "volCnt $volCnt"

    if (( $volCnt > 0 ));then

        printf '%s\n' '# Generated volumes' \
            'volumes:' \
            >>docker-compose.yml


        for index in "${!arr_volName[@]}"
        do
            #echo ">>>>>>${arr_volName[index]} ${arr_volDriver[index]} ${arr_volCreate[index]}"

            if (( ${arr_volCreate[index]} == 1 ));then
                printf '%s\n' "  ${arr_volName[index]}:" \
                    "    driver: ${arr_volDriver[index]}" \
                    >>docker-compose.yml
            fi

        done

    else

    echo "No volumes"

    fi

}

function _replaceMarkers {

    local input=$1

    echo -e "$1"

    local output=${input/scptdirreplace/$SCRIPT_DIR}
    local output=${output/ipreplace/${localDictionary[$REQUIRE_IPADDR_IDX]}}
    local output=${output/nwnamereplace1/$MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME}
    local output=${output/baseImagePrefix/$MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX}

    echo -e "$output"

}


__get_array_items_from_array() {

    local data="$(get_array_items $1 '.requires' '.volumes')"
   
    for row in $(echo "${data}" | jq -r '.[] | @base64'); do
        _jq() {
          echo ${row} | base64 --decode | jq -r ${1}
        }

        echo "$(_jq $2)"
    done

}
