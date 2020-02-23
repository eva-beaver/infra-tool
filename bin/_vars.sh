#!/usr/bin/env bash
#/*
# * Copyright 2014-2020 the original author or authors.
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

# emojipedia.org

WORKING_DIRECTORY=$(cd $(dirname $0); pwd)
DEBUG=0

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_DIR_PARENT="$(dirname "$SCRIPT_DIR")"

# Variables to hold parts of the manifest
MANIFEST_VERSION="v1.00"
MANIFEST_TYPE="java"
MANIFEST_TYPE_INFO_ID=0
MANIFEST_TYPE_INFO_NAME=""
MANIFEST_TYPE_INFO_REPOSITORY=""
MANIFEST_TYPE_INFO_DESCRIPTION=""
MANIFEST_TYPE_INFO_CATEGORIES=""
MANIFEST_TYPE_INFO_ENVIRONMENT=""

MANIFEST_BUILD_BUILDTYPE=""
MANIFEST_BUILD_JDK=""
MANIFEST_BUILD_TARGETJARNAME=""
MANIFEST_BUILD_COMMAND=""
MANIFEST_BUILD_TARGETDIR=0
MANIFEST_BUILD_USEWRAPPER=0
MANIFEST_BUILD_REMOVETARGET=0

MANIFEST_RUN_COMMAND=""
MANIFEST_RUN_TARGETJARNAME=""
MANIFEST_RUN_ENTRYPOINTCLASS=""
MANIFEST_RUN_JAVAOPTS=""

MANIFEST_TYPE_DOCKERFILE_GENERATE=1
MANIFEST_TYPE_DOCKERFILE_LOCATION="./"
MANIFEST_TYPE_DOCKERFILE_NAME="Dockerfile"

MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX=""
MANIFEST_TYPE_DOCKER_REPONAME=""
MANIFEST_TYPE_DOCKER_BUILDIMAGENAME=""
MANIFEST_TYPE_DOCKER_BASEIMAGENAME=""
MANIFEST_TYPE_DOCKER_CONTAINERNAME=""
MANIFEST_TYPE_DOCKER_VERSION=""
MANIFEST_TYPE_DOCKER_INSTANCENAME=""
MANIFEST_TYPE_DOCKER_TEMPLATEFILE=""
MANIFEST_TYPE_DOCKER_MULTISTAGEBUILD=0
MANIFEST_TYPE_DOCKER_PORTS=""
MANIFEST_TYPE_DOCKER_PORTS_ARR=""
MANIFEST_TYPE_DOCKER_MEMORY=""
MANIFEST_TYPE_DOCKER_SWAPMEMORY=""
MANIFEST_TYPE_DOCKER_REMOVEDOCKER=0
MANIFEST_TYPE_DOCKER_SAVEDOCKERRUN=0
MANIFEST_TYPE_DOCKER_HEALTH_CMD_EXISTS=0
MANIFEST_TYPE_DOCKER_HEALTH_CMD=""
MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL=""
MANIFEST_TYPE_DOCKER_HEALTH_RETRIES=""
MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT=""
MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD=""
MANIFEST_TYPE_DOCKER_NETWORK="localhost"
MANIFEST_TYPE_DOCKER_IPMASK=""
MANIFEST_TYPE_DOCKER_IPADDR=""
MANIFEST_TYPE_DOCKER_STARTNETWORK=0
MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES=""
MANIFEST_TYPE_DOCKER_USEDC=0
MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT=1
MANIFEST_TYPE_DOCKER_USEPROJECTDOCKERFILE=0
MANIFEST_TYPE_DOCKER_BUILDDOCKERIMAGE=1
MANIFEST_TYPE_DOCKER_STARTDOCKERIMAGE=1
MANIFEST_TYPE_DOCKER_PUSHDOCKERIMAGE=1

MANIFEST_TYPE_DOCKERCOMPOSE_VERSION="2"
MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME="local-net"
MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKTYPE="bridge"
MANIFEST_TYPE_DOCKERCOMPOSE_IPMASK=""
MANIFEST_TYPE_DOCKERCOMPOSE_MEMORY=""
MANIFEST_TYPE_DOCKERCOMPOSE_PROCESSORS=2
MANIFEST_TYPE_DOCKERCOMPOSE_STARTAFTERBUILD=1

# Arrys
MANIFEST_TYPE_DOCKER_ENVOPT_NAME=""
MANIFEST_TYPE_DOCKER_ENVOPT_VALUE=""

# Arrys
MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME=""
MANIFEST_TYPE_DOCKERNETWORKS_IPMASK=""

MAVEN_WRPPER="./mvnw"
GRADLE_WRPPER="./gradlew"

ARR_ENVIRONMENTS_NAME=""
ARR_ENVIRONMENTS_MEMORY=""
ARR_ENVIRONMENTS_INSTANCE=""

amqDictionary=''
prometheusDictionary=''
grafanaDictionary=''
springbootadminDictionary=''
elkDictionary=''
postgresDictionary=''

local_vol_name_arr=''
local_vol_driver_arr=''
local_vol_create_arr=''

myStack_vol_name_arr=''
myStack_vol_driver_arr=''
myStack_vol_create_arr=''

kafka_vol_name_arr=''
kafka_vol_driver_arr=''
kafka_vol_create_arr=''

amq_vol_name_arr=''
amq_vol_driver_arr=''
amq_vol_create_arr=''

grafana_vol_name_arr=''
grafana_vol_driver_arr=''
grafana_vol_create_arr=''

prometheus_vol_name_arr=''
prometheus_vol_driver_arr=''
prometheus_vol_create_arr=''

elk_vol_name_arr=''
elk_vol_driver_arr=''
elk_vol_create_arr=''

postgres_vol_name_arr=''
postgres_vol_driver_arr=''
postgres_vol_create_arr=''

springbootadmin_vol_name_arr=''
springbootadmin_vol_driver_arr=''
springbootadmin_vol_create_arr=''

REQUIRE_NAME_IDX=0
REQUIRE_REQUIRED_IDX=1
REQUIRE_IPADDR_IDX=2
REQUIRE_MEMORY_IDX=3
REQUIRE_TEMPLATE_IDX=4

ARR_REQUIRE_NAME=""
ARR_REQUIRE_TEMPLATE=""
ARR_REQUIRE_REQUIRED=""
ARR_REQUIRE_IPADDR=""
ARR_REQUIRE_MEMORY=""
ARR_REQUIRE_VOLUMES=""

# This is set if any requires have a volume section present
MANIFEST_TYPE_DOCKERCOMPOSE_VOL_REQUIRED=0


#     | 1a    2a    3a    4a    5a    6a   | 1b    2b    3b    4b    5b    6b
#     | [     ["    [-n   [-n"  [-z   [-z" | [[    [["   [[-n  [[-n" [[-z  [[-z"
#-----+------------------------------------+------------------------------------
#unset| false false true  false true  true | false false false false true  true
#null | false false true  false true  true | false false false false true  true
#space| false true  true  true  true  false| true  true  true  true  false false
#zero | true  true  true  true  false false| true  true  true  true  false false
#digit| true  true  true  true  false false| true  true  true  true  false false
#char | true  true  true  true  false false| true  true  true  true  false false
#hyphn| true  true  true  true  false false| true  true  true  true  false false
#two  | -err- true  -err- true  -err- false| true  true  true  true  false false
#part | -err- true  -err- true  -err- false| true  true  true  true  false false
#Tstr | true  true  -err- true  -err- false| true  true  true  true  false false
#Fsym | false true  -err- true  -err- false| true  true  true  true  false false
#T=   | true  true  -err- true  -err- false| true  true  true  true  false false
#F=   | false true  -err- true  -err- false| true  true  true  true  false false
#T!=  | true  true  -err- true  -err- false| true  true  true  true  false false
#F!=  | false true  -err- true  -err- false| true  true  true  true  false false
#Teq  | true  true  -err- true  -err- false| true  true  true  true  false false
#Feq  | false true  -err- true  -err- false| true  true  true  true  false false
#Tne  | true  true  -err- true  -err- false| true  true  true  true  false false
#Fne  | false true  -err- true  -err- false| true  true  true  true  false false
#