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

function loadRequires() {

    local manifestname=${1}

    echo "⏲️       Loading Manifest requires dictionaries"

    # Need to transfer dictionary object into fixed position array as dictinary
    # has random positions.

    local i=0 
    declare -A localDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "local")"

    for key in  "${!localDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            localDictionary[0]=${localDictionaryLocal[$key]};;
        *required*)
            localDictionary[1]=${localDictionaryLocal[$key]};;
        *ipAddr*)
            localDictionary[2]=${localDictionaryLocal[$key]};;
        *memory*)
            localDictionary[3]=${localDictionaryLocal[$key]};;
        *template*)
            localDictionary[4]=${localDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${localDictionaryLocal[$key]}"'"
        fi
        #kafkaDictionary[i]=${localDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    local i=0 
    declare -A myStackDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "myStack")"

    for key in  "${!myStackDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            myStackDictionary[0]=${myStackDictionaryLocal[$key]};;
        *required*)
            myStackDictionary[1]=${myStackDictionaryLocal[$key]};;
        *ipAddr*)
            myStackDictionary[2]=${myStackDictionaryLocal[$key]};;
        *memory*)
            myStackDictionary[3]=${myStackDictionaryLocal[$key]};;
        *template*)
            myStackDictionary[4]=${myStackDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${myStackDictionaryLocal[$key]}"'"
        fi
        #kafkaDictionary[i]=${myStackDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    local i=0 
    declare -A kafkaDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "kafka")"

    for key in  "${!kafkaDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            kafkaDictionary[0]=${kafkaDictionaryLocal[$key]};;
        *required*)
            kafkaDictionary[1]=${kafkaDictionaryLocal[$key]};;
        *ipAddr*)
            kafkaDictionary[2]=${kafkaDictionaryLocal[$key]};;
        *memory*)
            kafkaDictionary[3]=${kafkaDictionaryLocal[$key]};;
        *template*)
            kafkaDictionary[4]=${kafkaDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${kafkaDictionaryLocal[$key]}"'"
        fi
        #kafkaDictionary[i]=${kafkaDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    local i=0 
    declare -A amqDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "amq")"

    for key in  "${!amqDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            amqDictionary[0]=${amqDictionaryLocal[$key]};;
        *required*)
            amqDictionary[1]=${amqDictionaryLocal[$key]};;
        *ipAddr*)
            amqDictionary[2]=${amqDictionaryLocal[$key]};;
        *memory*)
            amqDictionary[3]=${amqDictionaryLocal[$key]};;
        *template*)
            amqDictionary[4]=${amqDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${amqDictionaryLocal[$key]}"'"
        fi
        #amqDictionary[i]=${amqDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    local i=0 
    declare -A prometheusDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "prometheus")"

    for key in  "${!prometheusDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            prometheusDictionary[0]=${prometheusDictionaryLocal[$key]};;
        *required*)
            prometheusDictionary[1]=${prometheusDictionaryLocal[$key]};;
        *ipAddr*)
            prometheusDictionary[2]=${prometheusDictionaryLocal[$key]};;
        *memory*)
            prometheusDictionary[3]=${prometheusDictionaryLocal[$key]};;
        *template*)
            prometheusDictionary[4]=${prometheusDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${prometheusDictionaryLocal[$key]}"'"
        fi
        #prometheusDictionary[i]=${prometheusDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    declare -A grafanaDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "grafana")"

    local i=0
    for key in  "${!grafanaDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            grafanaDictionary[0]=${grafanaDictionaryLocal[$key]};;
        *required*)
            grafanaDictionary[1]=${grafanaDictionaryLocal[$key]};;
        *ipAddr*)
            grafanaDictionary[2]=${grafanaDictionaryLocal[$key]};;
        *memory*)
            grafanaDictionary[3]=${grafanaDictionaryLocal[$key]};;
        *template*)
            grafanaDictionary[4]=${grafanaDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${grafanaDictionaryLocal[$key]}"'"
        fi
        #grafanaDictionary[i]=${grafanaDictionaryLocal[$key]}
        local i=$[$i +1]
     done

    declare -A springbootadminDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "springbootadmin")"

    local i=0
    for key in  "${!springbootadminDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            springbootadminDictionary[0]=${springbootadminDictionaryLocal[$key]};;
        *required*)
            springbootadminDictionary[1]=${springbootadminDictionaryLocal[$key]};;
        *ipAddr*)
            springbootadminDictionary[2]=${springbootadminDictionaryLocal[$key]};;
        *memory*)
            springbootadminDictionary[3]=${springbootadminDictionaryLocal[$key]};;
        *template*)
            springbootadminDictionary[4]=${springbootadminDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${springbootadminDictionaryLocal[$key]}"'"
        fi
        #springbootadminDictionary[i]=${springbootadminDictionaryLocal[$key]}
        local i=$[$i +1]
     done

    declare -A elkDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "elk")"

    local i=0
    for key in  "${!elkDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            elkDictionary[0]=${elkDictionaryLocal[$key]};;
        *required*)
            elkDictionary[1]=${elkDictionaryLocal[$key]};;
        *ipAddr*)
            elkDictionary[2]=${elkDictionaryLocal[$key]};;
        *memory*)
            elkDictionary[3]=${elkDictionaryLocal[$key]};;
        *template*)
            elkDictionary[4]=${elkDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${elkDictionaryLocal[$key]}"'"
        fi
        #elkDictionary[i]=${elkDictionaryLocal[$key]}
        local i=$[$i +1]
    done

    declare -A postgresDictionaryLocal="$(requiresDictionaryBuilder "${manifestname}" "postgres")"

    local i=0
    for key in  "${!postgresDictionaryLocal[@]}" ; do
        case "$key" in 
        *name*)
            postgresDictionary[0]=${postgresDictionaryLocal[$key]};;
        *required*)
            postgresDictionary[1]=${postgresDictionaryLocal[$key]};;
        *ipAddr*)
            postgresDictionary[2]=${postgresDictionaryLocal[$key]};;
        *memory*)
            postgresDictionary[3]=${postgresDictionaryLocal[$key]};;
        *template*)
            postgresDictionary[4]=${postgresDictionaryLocal[$key]};;
        esac
        if [ $DEBUG -eq 1 ];then
            echo "${key}: '"${postgresDictionaryLocal[$key]}"'"
        fi
        #elkDictionary[i]=${postgresDictionaryLocal[$key]}
        local i=$[$i +1]
     done

    # Convert to array delimted use space
    IFS=' ' read -r -a kafka_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.kafka.volumes' 'name')"
    IFS=' ' read -r -a kafka_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.kafka.volumes' 'driver')"
    IFS=' ' read -r -a kafka_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.kafka.volumes' 'create')"

    for index in "${!kafka_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.kafka.volumes"
    
        for index in "${!kafka_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${kafka_vol_name_arr[index]}"
            echo "$index ${kafka_vol_driver_arr[index]}"
            echo "$index ${kafka_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a amq_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.amq.volumes' 'name')"
    IFS=' ' read -r -a amq_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.amq.volumes' 'driver')"
    IFS=' ' read -r -a amq_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.amq.volumes' 'create')"

    for index in "${!amq_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.amq.volumes"
    
        for index in "${!amq_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${amq_vol_name_arr[index]}"
            echo "$index ${amq_vol_driver_arr[index]}"
            echo "$index ${amq_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a grafana_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.grafana.volumes' 'name')"
    IFS=' ' read -r -a grafana_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.grafana.volumes' 'driver')"
    IFS=' ' read -r -a grafana_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.grafana.volumes' 'create')"

    for index in "${!grafana_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.grafana.volumes"
    
        for index in "${!grafana_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${grafana_vol_name_arr[index]}"
            echo "$index ${grafana_vol_driver_arr[index]}"
            echo "$index ${grafana_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a prometheus_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.prometheus.volumes' 'name')"
    IFS=' ' read -r -a prometheus_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.prometheus.volumes' 'driver')"
    IFS=' ' read -r -a prometheus_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.prometheus.volumes' 'create')"

    for index in "${!prometheus_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.prometheus.volumes"
    
        for index in "${!prometheus_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${prometheus_vol_name_arr[index]}"
            echo "$index ${prometheus_vol_driver_arr[index]}"
            echo "$index ${prometheus_vol_create_arr[index]}"
        done
    fi

    if [ $DEBUG -eq 1 ];then
        local key=".requires.elk.volumes"
        local rslt=$(getJsonItem $manifestname $key "")
        echo ">>>>>>>>>>>>>>>>>>>>$rslt"
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a elk_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.elk.volumes' 'name')"
    IFS=' ' read -r -a elk_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.elk.volumes' 'driver')"
    IFS=' ' read -r -a elk_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.elk.volumes' 'create')"

    for index in "${!elk_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.elk.volumes"
    
        for index in "${!elk_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${elk_vol_name_arr[index]}"
            echo "$index ${elk_vol_driver_arr[index]}"
            echo "$index ${elk_vol_create_arr[index]}"
        done
    fi

    if [ $DEBUG -eq 1 ];then
        local key=".requires.elk.volumes"
        local rslt=$(getJsonItem $manifestname $key "")
        echo ">>>>>>>>>>>>>>>>>>>>$rslt"
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a postgres_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.postgres.volumes' 'name')"
    IFS=' ' read -r -a postgres_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.postgres.volumes' 'driver')"
    IFS=' ' read -r -a postgres_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.postgres.volumes' 'create')"

    for index in "${!postgres_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.postgres.volumes"
    
        for index in "${!postgres_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${postgres_vol_name_arr[index]}"
            echo "$index ${postgres_vol_driver_arr[index]}"
            echo "$index ${postgres_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a local_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.local.volumes' 'name')"
    IFS=' ' read -r -a local_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.local.volumes' 'driver')"
    IFS=' ' read -r -a local_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.local.volumes' 'create')"

    for index in "${!local_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.local.volumes"
    
        for index in "${!local_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${local_vol_name_arr[index]}"
            echo "$index ${local_vol_driver_arr[index]}"
            echo "$index ${local_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a myStack_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.myStack.volumes' 'name')"
    IFS=' ' read -r -a myStack_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.myStack.volumes' 'driver')"
    IFS=' ' read -r -a myStack_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.myStack.volumes' 'create')"

    for index in "${!myStack_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    if [ $DEBUG -eq 1 ];then

        echo "requires.myStack.volumes"
    
        for index in "${!myStack_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${myStack_vol_name_arr[index]}"
            echo "$index ${myStack_vol_driver_arr[index]}"
            echo "$index ${myStack_vol_create_arr[index]}"
        done
    fi

    # Convert to array delimted use space
    IFS=' ' read -r -a springbootadmin_vol_name_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.springbootadmin.volumes' 'name')"
    IFS=' ' read -r -a springbootadmin_vol_driver_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.springbootadmin.volumes' 'driver')"
    IFS=' ' read -r -a springbootadmin_vol_create_arr <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.requires.springbootadmin.volumes' 'create')"

    if [ $DEBUG -eq 1 ];then

        echo "requires.springbootadmin.volumes"
    
        for index in "${!springbootadmin_vol_name_arr[@]}"
        do
            MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
            echo "$index ${springbootadmin_vol_name_arr[index]}"
            echo "$index ${springbootadmin_vol_driver_arr[index]}"
            echo "$index ${springbootadmin_vol_create_arr[index]}"
        done
    fi

    for index in "${!springbootadmin_vol_name_arr[@]}"
    do
        MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=1
    done

    echo "✔️       Requires dictionay Loaded"

}

function requiresDictionaryBuilder() {

    local manifestname=${1}
    local requiretype=${2}

    echo '('
    
    local key=".requires.$requiretype.name"
    local rslt=$(getJsonItem $manifestname $key)
    echo "['$key']='$rslt'"

    local key=".requires.$requiretype.template"
    local rslt=$(getJsonItem $manifestname $key)
    echo "['$key']='$rslt'"

    local key=".requires.$requiretype.ipAddr"
    local rslt=$(getJsonItem $manifestname $key)
    echo "['$key']='$rslt'"

    local key=".requires.$requiretype.memory"
    local rslt=$(getJsonItem $manifestname $key)
    echo "['$key']='$rslt'"

    local key=".requires.$requiretype.required"
    local rslt=$(getJsonItem $manifestname $key)
    echo "['$key']='$rslt'"

    echo ')'

}
