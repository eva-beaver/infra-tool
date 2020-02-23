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


function loadManifest {

    local MANIFEST_NAME=${1}

    echo "⏲️       Loading Manifest [$MANIFEST_NAME]"

    MANIFEST_TYPE=$(getJsonItem $MANIFEST_NAME '.type' $MANIFEST_TYPE)
    MANIFEST_TYPE_INFO_ID=$(getJsonItem $MANIFEST_NAME '.info.id' $MANIFEST_TYPE_INFO_ID)
    MANIFEST_TYPE_INFO_NAME=$(getJsonItem $MANIFEST_NAME '.info.name' $MANIFEST_TYPE_INFO_NAME)
    MANIFEST_TYPE_INFO_REPOSITORY=$(getJsonItem $MANIFEST_NAME '.info.repository' $MANIFEST_TYPE_INFO_REPOSITORY)
    MANIFEST_TYPE_INFO_DESCRIPTION=$(getJsonItem $MANIFEST_NAME '.info.description' $MANIFEST_TYPE_INFO_DESCRIPTION)
    MANIFEST_TYPE_INFO_ENVIRONMENT=$(getJsonItem $MANIFEST_NAME '.info.environment' $MANIFEST_TYPE_INFO_ENVIRONMENT)
 
    MANIFEST_BUILD_BUILDTYPE=$(getJsonItem $MANIFEST_NAME '.build.buildType' $MANIFEST_BUILD_BUILDTYPE)
    MANIFEST_BUILD_JDK=$(getJsonItem $MANIFEST_NAME '.build.jdk' $MANIFEST_BUILD_JDK)
    MANIFEST_BUILD_TARGETJARNAME=$(getJsonItem $MANIFEST_NAME '.build.targetJarName' $MANIFEST_BUILD_TARGETJARNAME)
    MANIFEST_BUILD_COMMAND=$(getJsonItem $MANIFEST_NAME '.build.command' $MANIFEST_BUILD_COMMAND)
    MANIFEST_BUILD_TARGETDIR=$(getJsonItem $MANIFEST_NAME '.build.targetDir' $MANIFEST_BUILD_TARGETDIR)
    MANIFEST_BUILD_USEWRAPPER=$(getJsonItem $MANIFEST_NAME '.build.useWrapper' $MANIFEST_BUILD_USEWRAPPER)
    MANIFEST_BUILD_REMOVETARGET=$(getJsonItem $MANIFEST_NAME '.build.removeTarget' $MANIFEST_BUILD_REMOVETARGET)

    MANIFEST_RUN_COMMAND=$(getJsonItem $MANIFEST_NAME '.run.command' $MANIFEST_RUN_COMMAND)
    MANIFEST_RUN_TARGETJARNAME=$(getJsonItem $MANIFEST_NAME '.run.targetJarName' $MANIFEST_RUN_TARGETJARNAME)
    MANIFEST_RUN_ENTRYPOINTCLASS=$(getJsonItem $MANIFEST_NAME '.run.entryPointClass' $MANIFEST_RUN_ENTRYPOINTCLASS)
    MANIFEST_RUN_JAVAOPTS=$(getJsonItem $MANIFEST_NAME '.run.javaopts' $MANIFEST_RUN_JAVAOPTS)

    MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX=$(getJsonItem $MANIFEST_NAME '.docker.baseImagePrefix' $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX)
    MANIFEST_TYPE_DOCKER_REPONAME=$(getJsonItem $MANIFEST_NAME '.docker.repoName' $MANIFEST_TYPE_DOCKER_REPONAME)
    MANIFEST_TYPE_DOCKER_BUILDIMAGENAME=$(getJsonItem $MANIFEST_NAME '.docker.buildImageName' $MANIFEST_TYPE_DOCKER_BUILDIMAGENAME)
    MANIFEST_TYPE_DOCKER_BASEIMAGENAME=$(getJsonItem $MANIFEST_NAME '.docker.baseImageName' $MANIFEST_TYPE_DOCKER_BASEIMAGENAME)
    MANIFEST_TYPE_DOCKER_CONTAINERNAME=$(getJsonItem $MANIFEST_NAME '.docker.containerName' $MANIFEST_TYPE_DOCKER_CONTAINERNAME)
    MANIFEST_TYPE_DOCKER_VERSION=$(getJsonItem $MANIFEST_NAME '.docker.version' $MANIFEST_TYPE_DOCKER_VERSION)
    MANIFEST_TYPE_DOCKER_INSTANCENAME=$(getJsonItem $MANIFEST_NAME '.docker.instanceName' $MANIFEST_TYPE_DOCKER_INSTANCENAME)
    MANIFEST_TYPE_DOCKER_TEMPLATEFILE=$(getJsonItem $MANIFEST_NAME '.docker.dockerfileTemplate' $MANIFEST_TYPE_DOCKER_TEMPLATEFILE)
    MANIFEST_TYPE_DOCKER_MULTISTAGEBUILD=$(getJsonItem $MANIFEST_NAME '.docker.mutilStageBuild' $MANIFEST_TYPE_DOCKER_MULTISTAGEBUILD)

    MANIFEST_TYPE_DOCKER_PORTS=$(getJsonItem $MANIFEST_NAME '.docker.ports' $MANIFEST_TYPE_DOCKER_PORTS)

    IFS=',' read -ra MANIFEST_TYPE_DOCKER_PORTS_ARR <<< "$MANIFEST_TYPE_DOCKER_PORTS"
    
    MANIFEST_TYPE_DOCKER_REMOVEDOCKER=$(getJsonItem $MANIFEST_NAME '.docker.removeDocker' $MANIFEST_TYPE_DOCKER_REMOVEDOCKER)
    MANIFEST_TYPE_DOCKER_SAVEDOCKERRUN=$(getJsonItem $MANIFEST_NAME '.docker.saveDockerRun' $MANIFEST_TYPE_DOCKER_SAVEDOCKERRUN)
    
    local rslt=$(getJsonItem $MANIFEST_NAME '.docker.health')
 
    if [ "$rslt" == "null" ];then

        echo "⁉️       No health check found"

        MANIFEST_TYPE_DOCKER_HEALTH_CMD_EXISTS=0

    else

        echo "⭕       Health check found"

        MANIFEST_TYPE_DOCKER_HEALTH_CMD_EXISTS=1

        MANIFEST_TYPE_DOCKER_HEALTH_CMD=$(getJsonItem $MANIFEST_NAME '.docker.health.cmd' $MANIFEST_TYPE_DOCKER_HEALTH_CMD)
        MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL=$(getJsonItem $MANIFEST_NAME '.docker.health.interval' $MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL)
        MANIFEST_TYPE_DOCKER_HEALTH_RETRIES=$(getJsonItem $MANIFEST_NAME '.docker.health.retries' $MANIFEST_TYPE_DOCKER_HEALTH_RETRIES)
        MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT=$(getJsonItem $MANIFEST_NAME '.docker.health.timeout' $MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT)
        MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD=$(getJsonItem $MANIFEST_NAME '.docker.health.startperiod' $MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD)

    fi

    MANIFEST_TYPE_DOCKERFILE_GENERATE=$(getJsonItem $MANIFEST_NAME '.dockerfile.generate' $MANIFEST_TYPE_DOCKERFILE_GENERATE)
    MANIFEST_TYPE_DOCKERFILE_LOCATION=$(getJsonItem $MANIFEST_NAME '.dockerfile.location' $MANIFEST_TYPE_DOCKERFILE_LOCATION)
    MANIFEST_TYPE_DOCKERFILE_NAME=$(getJsonItem $MANIFEST_NAME '.dockerfile.name' $MANIFEST_TYPE_DOCKERFILE_NAME)

    MANIFEST_TYPE_DOCKER_NETWORK=$(getJsonItem $MANIFEST_NAME '.docker.network' $MANIFEST_TYPE_DOCKER_NETWORK)
    MANIFEST_TYPE_DOCKER_IPMASK=$(getJsonItem $MANIFEST_NAME '.docker.ipMask' $MANIFEST_TYPE_DOCKER_IPMASK)
    MANIFEST_TYPE_DOCKER_IPADDR=$(getJsonItem $MANIFEST_NAME '.docker.ipAddr' $MANIFEST_TYPE_DOCKER_IPADDR)
    MANIFEST_TYPE_DOCKER_STARTNETWORK=$(getJsonItem $MANIFEST_NAME '.docker.startNetwork' $MANIFEST_TYPE_DOCKER_STARTNETWORK)
    MANIFEST_TYPE_DOCKER_MEMORY=$(getJsonItem $MANIFEST_NAME '.docker.memory' $MANIFEST_TYPE_DOCKER_MEMORY)
    MANIFEST_TYPE_DOCKER_SWAPMEMORY=$(getJsonItem $MANIFEST_NAME '.docker.swapMemory' $MANIFEST_TYPE_DOCKER_SWAPMEMORY)
    MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES=$(getJsonItem $MANIFEST_NAME '.docker.springBootProfiles' $MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES)
    MANIFEST_TYPE_DOCKER_USEDC=$(getJsonItem $MANIFEST_NAME '.docker.useInDockerCompose' $MANIFEST_TYPE_DOCKER_USEDC)
    MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT=$(getJsonItem $MANIFEST_NAME '.docker.dockerFileFormatVersion' $MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT)
    MANIFEST_TYPE_DOCKER_USEPROJECTDOCKERFILE=$(getJsonItem $MANIFEST_NAME '.docker.useProjectDockerIFile' $MANIFEST_TYPE_DOCKER_USEPROJECTDOCKERFILE)
    MANIFEST_TYPE_DOCKER_BUILDDOCKERIMAGE=$(getJsonItem $MANIFEST_NAME '.docker.buildDockerImage' $MANIFEST_TYPE_DOCKER_BUILDDOCKERIMAGE)
    MANIFEST_TYPE_DOCKER_STARTDOCKERIMAGE=$(getJsonItem $MANIFEST_NAME '.docker.startDockerImage' $MANIFEST_TYPE_DOCKER_STARTDOCKERIMAGE)
    MANIFEST_TYPE_DOCKER_PUSHDOCKERIMAGE=$(getJsonItem $MANIFEST_NAME '.docker.pushDockerImage' $MANIFEST_TYPE_DOCKER_PUSHDOCKERIMAGE)

    MANIFEST_TYPE_DOCKER_ENVOPT_NAME=$(getJsonIndexItemByName $MANIFEST_NAME '.docker.environmentOptions' 'name')
    MANIFEST_TYPE_DOCKER_ENVOPT_VALUE=$(getJsonIndexItemByName $MANIFEST_NAME '.docker.environmentOptions' 'value')

    # Convert to array delimted use space
    IFS=' ' read -r -a MANIFEST_TYPE_DOCKER_ENVOPT_NAME <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.docker.environmentOptions' 'name')"
    IFS=' ' read -r -a MANIFEST_TYPE_DOCKER_ENVOPT_VALUE <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.docker.environmentOptions' 'value')"

    MANIFEST_TYPE_DOCKERCOMPOSE_VERSION=$(getJsonItem $MANIFEST_NAME '.dockerCompose.version' $MANIFEST_TYPE_DOCKERCOMPOSE_VERSION)
    MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME=$(getJsonItem $MANIFEST_NAME '.dockerCompose.networkName' $MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME)
    MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKTYPE=$(getJsonItem $MANIFEST_NAME '.dockerCompose.networkType' $MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKTYPE)
    MANIFEST_TYPE_DOCKERCOMPOSE_IPMASK=$(getJsonItem $MANIFEST_NAME '.dockerCompose.ipMask' $MANIFEST_TYPE_DOCKERCOMPOSE_IPMASK)
    MANIFEST_TYPE_DOCKERCOMPOSE_MEMORY=$(getJsonItem $MANIFEST_NAME '.dockerCompose.memory' $MANIFEST_TYPE_DOCKERCOMPOSE_MEMORY)
    MANIFEST_TYPE_DOCKERCOMPOSE_PROCESSORS=$(getJsonItem $MANIFEST_NAME '.dockerCompose.processors' $MANIFEST_TYPE_DOCKERCOMPOSE_PROCESSORS)
    MANIFEST_TYPE_DOCKERCOMPOSE_STARTAFTERBUILD=$(getJsonItem $MANIFEST_NAME '.dockerCompose.startAfterBuild' $MANIFEST_TYPE_DOCKERCOMPOSE_STARTAFTERBUILD)

    MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME=$(getJsonIndexItemByName $MANIFEST_NAME '.dockerCompose.dockerNetworks' 'networkName')
    MANIFEST_TYPE_DOCKERNETWORKS_IPMASK=$(getJsonIndexItemByName $MANIFEST_NAME '.dockerCompose.dockerNetworks' 'ipMask')

    # Build an array from each item in environments array
    ARR_ENVIRONMENTS_NAME=(`echo "$(get_array_items $MANIFEST_NAME '.environments' '.name')"`);
    ARR_ENVIRONMENTS_MEMORY=(`echo "$(get_array_items $MANIFEST_NAME '.environments' '.memory')"`);
    ARR_ENVIRONMENTS_INSTANCES=(`echo "$(get_array_items $MANIFEST_NAME '.environments' '.memory')"`);
 
    # Build an array from each item in requires array
    ARR_REQUIRE_NAME=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.name')"`);
    ARR_REQUIRE_TEMPLATE=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.template')"`);
    ARR_REQUIRE_REQUIRED=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.required')"`);
    ARR_REQUIRE_IPADDR=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.ipAddr')"`);
    ARR_REQUIRE_MEMORY=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.memory')"`);
    ARR_REQUIRE_VOLUMES=(`echo "$(get_array_items $MANIFEST_NAME '.requires' '.volumes')"`);

    #echo "$(get_array_items $MANIFEST_NAME '.requires' '.volumes')"

    #local data="$(get_array_items $MANIFEST_NAME '.requires' '.volumes')"
   
    #for row in $(echo "${data}" | jq -r '.[] | @base64'); do
    #    _jq() {
    #      echo ${row} | base64 --decode | jq -r ${1}
    #    }
    #
    #    echo "$(_jq '.volDriver')"
    #done

    # Convert to array delimted use space
    IFS=' ' read -r -a MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.dockerCompose.dockerNetworks' 'networkName')"
    IFS=' ' read -r -a MANIFEST_TYPE_DOCKERNETWORKS_IPMASK <<< "$(getJsonIndexItemByName $MANIFEST_NAME '.dockerCompose.dockerNetworks' 'ipMask')"

    #RESULT=$(getJsonItem $MANIFEST_NAME '.xxx')

    if [ $DEBUG -eq 1 ];then
        printManifest
    fi

    _validateManifest

    echo "✔️       Manifest Loaded"

}

function _validateManifest {
#Todo:

    echo "⏳       Validating Manifest [$MANIFEST_NAME]"

    echo "✔️       Manifest is valid"

}

function printManifest {

    echo "version [$MANIFEST_VERSION]"
    echo "type [$MANIFEST_TYPE]"
    echo "info.id [$MANIFEST_TYPE_INFO_ID]"
    echo "info.name [$MANIFEST_TYPE_INFO_NAME]"
    echo "info.repository [$MANIFEST_TYPE_INFO_REPOSITORY]"
    echo "info.description [$MANIFEST_TYPE_INFO_DESCRIPTION]"
    echo "info.environment [$MANIFEST_TYPE_INFO_ENVIRONMENT]"
 
    echo "build.buildType [$MANIFEST_BUILD_BUILDTYPE]"
    echo "build.jdk [$MANIFEST_BUILD_JDK]"
    echo "build.targetJarName [$MANIFEST_BUILD_TARGETJARNAME]"
    echo "build.command [$MANIFEST_BUILD_COMMAND]"
    echo "build.targetDir [$MANIFEST_BUILD_TARGETDIR]"
    echo "build.useWrapper [$MANIFEST_BUILD_USEWRAPPER]"
    echo "build.removeTarget [$MANIFEST_BUILD_REMOVETARGET]"

    echo "run.command [$MANIFEST_RUN_COMMAND]"
    echo "run.targetJarName [$MANIFEST_RUN_TARGETJARNAME]"
    echo "run.targetJarName [$MANIFEST_RUN_ENTRYPOINTCLASS]"
    echo "run.targetJarName [$MANIFEST_RUN_JAVAOPTS]"

    echo "dockerFile.generate [$MANIFEST_TYPE_DOCKERFILE_GENERATE]"
    echo "dockerFile.location [$MANIFEST_TYPE_DOCKERFILE_LOCATION]"
    echo "dockerFile.name [$MANIFEST_TYPE_DOCKERFILE_NAME]"

    echo "docker.baseImagePrefix [$MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX]"
    echo "docker.repoName [$MANIFEST_TYPE_DOCKER_REPONAME]"
    echo "docker.buildImageName [$MANIFEST_TYPE_DOCKER_BUILDIMAGENAME]"
    echo "docker.baseImageName [$MANIFEST_TYPE_DOCKER_BASEIMAGENAME]"
    echo "docker.containerName [$MANIFEST_TYPE_DOCKER_CONTAINERNAME]"
    echo "docker.version [$MANIFEST_TYPE_DOCKER_VERSION]"
    echo "docker.instanceName [$MANIFEST_TYPE_DOCKER_INSTANCENAME]"
    echo "docker.dockerfileTemplate [$MANIFEST_TYPE_DOCKER_TEMPLATEFILE]"
    echo "docker.mutilStageBuild [$MANIFEST_TYPE_DOCKER_MULTISTAGEBUILD]"

    echo "docker.ports [$MANIFEST_TYPE_DOCKER_PORTS]"

    for port in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
    do
        echo $port
    done

    echo "docker.memory [$MANIFEST_TYPE_DOCKER_MEMORY]"
    echo "docker.swapMemory [$MANIFEST_TYPE_DOCKER_SWAPMEMORY]"
    echo "docker.removeDocker [$MANIFEST_TYPE_DOCKER_REMOVEDOCKER]"
    echo "docker.saveDockerRun [$MANIFEST_TYPE_DOCKER_SAVEREMOVEDOCKER]"
    echo "docker.health.cmd [$MANIFEST_TYPE_DOCKER_HEALTH_CMD]"
    echo "docker.health.interval [$MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL]"
    echo "docker.health.retries [$MANIFEST_TYPE_DOCKER_HEALTH_RETRIES]"
    echo "docker.health.timeout [$MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT]"
    echo "docker.health.startperiod [$MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD]"
    echo "docker.network [$MANIFEST_TYPE_DOCKER_NETWORK]"
    echo "docker.ipMask [$MANIFEST_TYPE_DOCKER_IPMASK]"
    echo "docker.ipAddr [$MANIFEST_TYPE_DOCKER_IPADDR]"
    echo "docker.startNetwork [$MANIFEST_TYPE_DOCKER_STARTNETWORK]"
    echo "docker.springBootProfiles [$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES]"
    echo "docker.useInDockerCompose [$MANIFEST_TYPE_DOCKER_USEDC]"
    echo "docker.dockerFileFormatVersion [$MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT]"
    echo "docker.useProjectDockerIFile [$MANIFEST_TYPE_DOCKER_USEPROJECTDOCKERFILE]"
    echo "docker.buildDockerImage [$MANIFEST_TYPE_DOCKER_BUILDDOCKERIMAGE]"
    echo "docker.startDockerImage [$MANIFEST_TYPE_DOCKER_STARTDOCKERIMAGE]"
    echo "docker.pushDockerImage [$MANIFEST_TYPE_DOCKER_PUSHDOCKERIMAGE]"

    echo "docker.environmentOptions"

    local i=0
    for obj in ${MANIFEST_TYPE_DOCKER_ENVOPT_NAME[@]}; do
        echo "        $obj $MANIFEST_TYPE_DOCKER_ENVOPT_VALUE[2]" 
        i+=1
    done

    for index in "${!MANIFEST_TYPE_DOCKER_ENVOPT_NAME[@]}"
    do
        echo "$index ${MANIFEST_TYPE_DOCKER_ENVOPT_NAME[index]}=${MANIFEST_TYPE_DOCKER_ENVOPT_VALUE[index]}"
    done

    echo "dockerCompose.version [$MANIFEST_TYPE_DOCKERCOMPOSE_VERSION]"
    echo "dockerCompose.networkName [$MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKNAME]"
    echo "dockerCompose.networkTupe [$MANIFEST_TYPE_DOCKERCOMPOSE_NETWORKTYPE]"
    echo "dockerCompose.ipMask [$MANIFEST_TYPE_DOCKERCOMPOSE_IPMASK]"
    echo "dockerCompose.memory [$MANIFEST_TYPE_DOCKERCOMPOSE_MEMORY]"
    echo "dockerCompose.processors [$MANIFEST_TYPE_DOCKERCOMPOSE_PROCESSORS]"
    echo "dockerCompose.startAfterBuild [$MANIFEST_TYPE_DOCKERCOMPOSE_STARTAFTERBUILD]"

    echo "dockerCompose.dockerNetworks"

    local i=0
    for obj in ${MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME[@]}; do
        echo "        $obj $MANIFEST_TYPE_DOCKERNETWORKS_IPMASK[2]" 
        i+=1
    done

    for index in "${!MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME[@]}"
    do
        echo "$index ${MANIFEST_TYPE_DOCKERNETWORKS_NETWORKNAME[index]}=${MANIFEST_TYPE_DOCKERNETWORKS_IPMASK[index]}"
    done

    echo "Environments for the docker-compose manifest"

    # Show what is the Environments for the docker-compose manifest
    for index in "${!ARR_ENVIRONMENTS_NAME[@]}"
    do
        echo "$index ${ARR_ENVIRONMENTS_NAME[index]}"
    done

    echo "Required for the docker-compose manifest"

    # Show what is required for the docker-compose manifest
    for index in "${!ARR_REQUIRE_NAME[@]}"
    do
        echo "$index ${ARR_REQUIRE_NAME[index]} ${ARR_REQUIRE_REQUIRED[index]}"
    done

}
