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
#

. $(dirname $0)/_common.sh
. $(dirname $0)/_vars.sh

. ~/.sdkman/bin/sdkman-init.sh


function buildGradleProject {

    echo "⏲️       Starting build for $MANIFEST_TYPE_INFO_NAME"

    require gradle

    if [ $MANIFEST_BUILD_USEWRAPPER -eq 1 ];then
      cmd=$GRADLE_WRPPER
    else
      cmd="gradle"
    fi

    local BUILDCMD="$cmd $MANIFEST_BUILD_COMMAND" 

    echo "🔩       Running [$BUILDCMD]"

    eval $BUILDCMD

  	if [[ "$?" -ne 0 ]] ; then
    	echo '❌        build failure'; exit 1
  	else
    	echo "👌       build success"
  	fi
 
    echo "✔️       Build complete"

}
