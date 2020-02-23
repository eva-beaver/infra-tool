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
 
# remove exited containers
echo "Removing old containers"
CONTAINERS=$(docker ps -a -q --no-trunc --filter "status=exited")

if [ -n "${CONTAINERS}" ]
then
   echo ${CONTAINERS} | xargs docker rm -v
fi

# remove all docker images that are month old
echo "Removing old images"

#IMAGES=$(docker images --no-trunc -a | grep -v springadminclientservice | grep 'months\|weeks\|days\|hours' | awk '{if (NR!=12) {print $3}}')
IMAGES=$(docker images --no-trunc -a | grep springadminclientservice | grep 'months\|weeks\|days\|hours' | awk '{if (NR!=12) {print $3}}')

if [ -n "${IMAGES}" ]
then
   echo ${IMAGES} | xargs docker rmi -f
fi

# remove old volumes
echo "Removing old volumes"
VOLUMES=$(docker volume ls -qf "dangling=true")

if [ -n "${VOLUMES}" ]
then
   echo ${VOLUMES} | xargs docker volume rm
fi
