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
 
# https://cleanprogrammer.net/automate-the-build-process-for-project-release-using-bash-script/

. $(dirname $0)/_common.sh
. $(dirname $0)/_vars.sh
. $(dirname $0)/_dockerfile.sh

function _generateDockerfile {

    if [ $MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT -eq 0 ];then
      echo "🔩       Copying dockefile from $MANIFEST_TYPE_DOCKER_TEMPLATEFILE"
      cp $MANIFEST_TYPE_DOCKER_TEMPLATEFILE .
    fi
                 
    if [ "$MANIFEST_TYPE_DOCKER_MULTISTAGEBUILD" -eq 0 ];then

      if [ $MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT -eq 1 ];then
        _generateDockerfilev1
      fi

      if [ $MANIFEST_TYPE_DOCKER_DOCKERFILEFORMAT -eq 2 ];then
        _generateDockerfilev2
      fi

    else

      _generateDockerfilev3

    fi

}

function buildDockerImage {

    echo "⏲️       Starting Dockerisation for $MANIFEST_TYPE_INFO_NAME"

    require docker

    local DOCKERCMD="docker build --force-rm -t $MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION . "
   
    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        build failure"; exit 1
    else
  	  echo "👌       build success"
    fi
 
    if [[ "${MANIFEST_BUILD_REMOVETARGET}" -ne 0 ]]; then
      if [[ "$MANIFEST_BUILD_BUILDTYPE" == "Maven" ]] ; then
        rm -rf ./target
      else
        rm -rf ./build
      fi
   	  echo "👌       deleted target"
    fi

    echo "✔️       Build complete"

}

function runDockerProject {

    echo "⏲️       Starting docker image $MANIFEST_TYPE_INFO_NAME"

    require docker

    printf '%s\n' "# Generated $(date) Using version $MANIFEST_VERSION" \
        "docker run \\" \
        " --name=$MANIFEST_TYPE_DOCKER_INSTANCENAME \\"  \
        >DockerRunFile.sh

    if [ $MANIFEST_TYPE_DOCKER_HEALTH_CMD_EXISTS -eq 1 ];then
      
      local health=${MANIFEST_TYPE_DOCKER_HEALTH_CMD/dockernwreplace/$MANIFEST_TYPE_DOCKER_NETWORK}
      health=${health/dockeripreplace/$MANIFEST_TYPE_DOCKER_IPADDR}

      health="\"$health\""
      printf '%s\n' " --health-cmd=$health \\" \
          " --health-interval=$MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL \\"  \
          " --health-retries=$MANIFEST_TYPE_DOCKER_HEALTH_RETRIES \\"  \
          " --health-timeout=$MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT \\"  \
          " --health-start-period=$MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD \\"  \
          >>DockerRunFile.sh
 
    fi

    if [ -n "$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES" ];then
      printf '%s\n' " -e \"SPRING_PROFILES_ACTIVE=$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES\" \\" \
        >>DockerRunFile.sh
    fi

    # Add environment variables for Java
    for i in ${!MANIFEST_TYPE_DOCKER_ENVOPT_NAME[@]}; do
      local javaEnv="${MANIFEST_TYPE_DOCKER_ENVOPT_NAME[i]}=${MANIFEST_TYPE_DOCKER_ENVOPT_VALUE[i]}" 
      #echo $javaEnv
      printf '%s\n' " -e \"$javaEnv\" \\" \
        >>DockerRunFile.sh
    done

    if [ -n "$MANIFEST_TYPE_DOCKER_MEMORY" ];then
      printf '%s\n' " -m $MANIFEST_TYPE_DOCKER_MEMORY \\" \
       >>DockerRunFile.sh
    fi

    if [ -n "$MANIFEST_TYPE_DOCKER_SWAPMEMORY" ];then
      printf '%s\n' " --memory-swap $MANIFEST_TYPE_DOCKER_SWAPMEMORY \\" \
       >>DockerRunFile.sh
    fi

    if [ -n "$MANIFEST_TYPE_DOCKER_NETWORK" ];then
      printf '%s\n' " --net=$MANIFEST_TYPE_DOCKER_NETWORK \\" \
       >>DockerRunFile.sh
    fi

    if [ -n "$MANIFEST_TYPE_DOCKER_IPADDR" ];then
      printf '%s\n' " --ip $MANIFEST_TYPE_DOCKER_IPADDR \\" \
        >>DockerRunFile.sh
    fi

    for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
    do
      printf '%s\n' " -p $ports \\" \
        >>DockerRunFile.sh
    done

    printf '%s\n' " -d \\" \
        " $MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION;"  \
        >>DockerRunFile.sh

    if [ $DEBUG -eq 1 ];then
        cat DockerRunFile.sh
    fi
 
    eval chmod +x DockerRunFile.sh

    echo "🔩       Running [$DOCKERCMD]"

    eval ./DockerRunFile.sh

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker image failed to start"; exit 1
  	else
    	echo "👌       docker image $MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION started successfully"
  	fi
  
    if [ $MANIFEST_TYPE_DOCKER_SAVEDOCKERRUN -ne 1 ];then
      eval rm DockerRunFile.sh
    fi

    docker ps

    echo "✔️       docker image start complete"

}

function runDockerProjectv1 {

    echo "⏲️       Starting docker image $MANIFEST_TYPE_INFO_NAME"

    require docker

    local DOCKERCMD=""
          DOCKERCMD+=$'docker run '
          DOCKERCMD+=$" --name=$MANIFEST_TYPE_DOCKER_INSTANCENAME " 

    # check for health check required
    if [ $MANIFEST_TYPE_DOCKER_HEALTH_CMD_EXISTS -eq 1 ];then
 
      local health="\"$MANIFEST_TYPE_DOCKER_HEALTH_CMD\""
      DOCKERCMD+=$" --health-cmd=$health "
      DOCKERCMD+=$" --health-interval=$MANIFEST_TYPE_DOCKER_HEALTH_INTERVAL "
      DOCKERCMD+=$" --health-retries=$MANIFEST_TYPE_DOCKER_HEALTH_RETRIES "
      DOCKERCMD+=$" --health-timeout=$MANIFEST_TYPE_DOCKER_HEALTH_TIMEOUT "
      DOCKERCMD+=$" --health-start-period=$MANIFEST_TYPE_DOCKER_HEALTH_STARTPERIOD "

    fi

    # Do we have any springboot profiles?
    if [ -n "$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES" ];then
        DOCKERCMD+=$" -e \"SPRING_PROFILES_ACTIVE=$MANIFEST_TYPE_DOCKER_SPRINGBOOTPROFILES\" "
    fi

    # Add environment variables for Java if any have been supplied
    for i in ${!MANIFEST_TYPE_DOCKER_ENVOPT_NAME[@]}; do
        local javaEnv="${MANIFEST_TYPE_DOCKER_ENVOPT_NAME[i]}=${MANIFEST_TYPE_DOCKER_ENVOPT_VALUE[i]}" 
        #echo $javaEnv
        DOCKERCMD+=$" -e \"$javaEnv\""
    done

    if [ -n "$MANIFEST_TYPE_DOCKER_NETWORK" ];then
      DOCKERCMD+=$" --net=$MANIFEST_TYPE_DOCKER_NETWORK "
    fi

    if [ -n "$MANIFEST_TYPE_DOCKER_IPADDR" ];then
      DOCKERCMD+=$" --ip $MANIFEST_TYPE_DOCKER_IPADDR "
    fi

    for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
    do
        DOCKERCMD+=$" -p $ports "
    done

    DOCKERCMD+=$' -d '
    DOCKERCMD+=$" $MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION;"

    if [ $DEBUG -eq 1 ];then
        echo $DOCKERCMD
    fi

    if [ $MANIFEST_TYPE_DOCKER_SAVEDOCKERRUN -eq 1 ];then
      printf '%s\n' "# Generated $(date) Using version $MANIFEST_VERSION" \
        "$DOCKERCMD" \
          '' >DockerfileFile.sh
      eval chmod +x DockerfileFile.sh
    fi

    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker image failed to start"; exit 1
  	else
    	echo "👌       docker image $MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION started successfully"
  	fi
 
    docker ps

    echo "✔️       docker image start complete"

}

function stopDockerProject {

    echo "⏲️       Stopping docker image $MANIFEST_TYPE_INFO_NAME"

    local DOCKERCMD="docker stop $MANIFEST_TYPE_DOCKER_INSTANCENAME"
   
    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker instance $MANIFEST_TYPE_DOCKER_INSTANCENAME is not running"
    else
  	  echo "👌       Image stop successful"
    fi

    echo "✔️       Image Stop complete"

}

function rmDockerProject {

    echo "⏲️       Removing docker image $MANIFEST_TYPE_INFO_NAME"

    local DOCKERCMD="docker rm $MANIFEST_TYPE_DOCKER_INSTANCENAME"
   
    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker instance $MANIFEST_TYPE_DOCKER_INSTANCENAME does not exist"
    else
  	  echo "👌       remove successful"
    fi

    echo "✔️       Remove image complete"

}

function tagDockerProject {

    echo "⏲️       Taging docker image $MANIFEST_TYPE_INFO_NAME"
        
    local cmd="docker images --filter=reference='$MANIFEST_TYPE_DOCKER_CONTAINERNAME*:$MANIFEST_TYPE_DOCKER_VERSION*' -q"
  
    local IMAGEID=$(eval "$cmd")

    #echo "IMAGEID=[$IMAGEID]"

    local DOCKERCMD="docker tag $IMAGEID $MANIFEST_TYPE_DOCKER_REPONAME/$MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION"
   
    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker instance $MANIFEST_TYPE_DOCKER_INSTANCENAME does not exist"
    else
  	  echo "👌       Tagged successful"
    fi

    echo "✔️       Tag complete"

}

function pushDockerProject {

    echo "⏲️       Pushing docker image $MANIFEST_TYPE_INFO_NAME"

    local DOCKERCMD="docker push $MANIFEST_TYPE_DOCKER_REPONAME/$MANIFEST_TYPE_DOCKER_CONTAINERNAME:$MANIFEST_TYPE_DOCKER_VERSION"
   
    echo "🔩       Running [$DOCKERCMD]"

    eval $DOCKERCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo "❌        docker instance $MANIFEST_TYPE_DOCKER_INSTANCENAME does not exist"
    else
  	  echo "👌       Pushed successful"
    fi

    echo "✔️       Push complete"

}

function createNetwork {
    
    if [ -z "$2" ];then
      echo "⏲️       Creating Docker network $1"
      local networks=$(docker network create --driver=bridge $1)
    else 
      echo "⏲️       Creating Docker network $1 - $2"
      echo "docker network create --driver=bridge --subnet=$2 $1"
      local networks=$(docker network create --driver=bridge --subnet=$2 $1)
    fi

    if [ -n "${networks}" ]
    then
  	  echo "👌       Network Created successfully"
    fi

}

function removeNetwork {

    echo "⏲️       Removing Docker network $1"
    
    local networks=$(docker network ls  --filter name=$1 -q)

    if [ -n "${networks}" ]
    then
      echo ${networks} | xargs docker network rm 
  	  echo "👌       Network Removed successfully"
    fi

}

function removeExitedContainers {

    echo "⏲️       Removing Exited Containers"
    
    local CONTAINERS=$(docker ps -a -q --no-trunc --filter "status=exited")

    if [ -n "${CONTAINERS}" ]
    then
      echo ${CONTAINERS} | xargs docker rm -v
    fi

}

function removeOldVolumes {

    echo "⏲️       Removing Old Volumes"

    local VOLUMES=$(docker volume ls -qf "dangling=true")

    if [ -n "${VOLUMES}" ]
    then
      echo ${VOLUMES} | xargs docker volume rm
    fi

}
