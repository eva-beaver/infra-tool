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

function _generateDockerfilev1 {

  echo "🔩       Generating docker file for $MANIFEST_TYPE_INFO_NAME for version 1"

  printf '%s\n' "# Generated $(date) Using version $MANIFEST_VERSION - V1" \
      "FROM $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX$MANIFEST_TYPE_DOCKER_BASEIMAGENAME" '' \
      'RUN mkdir /usr/myapp' \
         >Dockerfile

  printf '%s\n' '' \
      "ENV JAVA_OPTS=$MANIFEST_RUN_JAVAOPTS" \
          >>Dockerfile
        
  if [[ "$MANIFEST_BUILD_BUILDTYPE" == "Maven" ]] ; then
    printf '%s\n' '' \
        "COPY ./target/$MANIFEST_BUILD_TARGETJARNAME.jar /usr/myapp/app.jar" \
          >>Dockerfile
  else
    printf '%s\n' '' \
        "COPY ./build/libs/$MANIFEST_BUILD_TARGETJARNAME.jar /usr/myapp/app.jar" \
          >>Dockerfile
  fi

  printf '%s\n' '' \
    'WORKDIR /usr/myapp' \
       >>Dockerfile

  for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
  do
      IFS=':' read -ra port <<< "$ports"
      printf '%s\n' \
          "EXPOSE $port" >>Dockerfile
  done
      
  printf '%s\n' '' \
      'ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]' \
      >>Dockerfile

  if [ $DEBUG -eq 1 ];then
      cat Dockerfile
  fi

  if [[ "$?" -ne 0 ]] ; then
    echo "❌        build failure"; exit 1
  else
    echo "👌       build success"
  fi

  echo "✔️       Build complete"

}

function _generateDockerfilev2 {

  echo "🔩       Generating docker file for $MANIFEST_TYPE_INFO_NAME for version 2"

  printf '%s\n' "# Generated $(date) Using version $MANIFEST_VERSION - V2" \
    "FROM $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX$MANIFEST_TYPE_DOCKER_BASEIMAGENAME" '' \
      >Dockerfile

  printf '%s\n' "ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS" \
        >>Dockerfile

  printf '%s\n' '' \
      "ENV JAVA_OPTS=$MANIFEST_RUN_JAVAOPTS" \
          >>Dockerfile

  printf '%s\n' '' \
    'VOLUME /tmp' \
      >>Dockerfile

  printf '%s\n' '' \
    'RUN mkdir /usr/myapp' \
      >>Dockerfile
      
  if [[ "$MANIFEST_BUILD_BUILDTYPE" == "Maven" ]] ; then
      printf '%s\n' '' \
          "COPY ./target/$MANIFEST_BUILD_TARGETJARNAME.jar app.jar" \
          >>Dockerfile
  else
      printf '%s\n' '' \
          "COPY ./build/libs/$MANIFEST_BUILD_TARGETJARNAME.jar app.jar" \
          >>Dockerfile
  fi

  printf '%s\n' '' \
      "RUN sh -c 'touch /app.jar'" \
          >>Dockerfile

  for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
  do
      IFS=':' read -ra port <<< "$ports"
      printf '%s\n' \
          "EXPOSE $port" >>Dockerfile
  done
      
  printf '%s\n' '' \
      'ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]' \
          >>Dockerfile

  if [ $DEBUG -eq 1 ];then
      cat Dockerfile
  fi

  if [[ "$?" -ne 0 ]] ; then
      echo "❌        build failure"; exit 1
  else
      echo "👌       build success"
  fi

  echo "✔️       Build complete"

}

# Multistage build to make a smaller image
# https://spring.io/guides/gs/spring-boot-kubernetes/
function _generateDockerfilev3 {

  echo "🔩       Generating docker file for $MANIFEST_TYPE_INFO_NAME for version 3"

  printf '%s\n' "# Generated $(date) Using version $MANIFEST_VERSION - V3" \
    >Dockerfile

  #printf '%s\n' "FROM $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX$MANIFEST_TYPE_DOCKER_BASEIMAGENAME AS builder" \
  printf '%s\n' "FROM $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX$MANIFEST_TYPE_DOCKER_BUILDIMAGENAME AS builder" \
         >>Dockerfile

  printf '%s\n' "WORKDIR target/dependency" \
      "ARG APPJAR=target/*.jar" \
      "COPY \${APPJAR} app.jar" \
      "RUN jar -xf ./app.jar" '' \
        >>Dockerfile

  # Now build deploy docker image

  printf '%s\n' "FROM $MANIFEST_TYPE_DOCKER_BASEIMAGEPREFIX$MANIFEST_TYPE_DOCKER_BASEIMAGENAME" \
         >>Dockerfile

  printf '%s\n' '' \
      "VOLUME /tmp" \
      "ARG DEPENDENCY=target/dependency" \
      "COPY --from=builder \${DEPENDENCY}/BOOT-INF/lib /app/lib" \
      "COPY --from=builder \${DEPENDENCY}/META-INF /app/META-INF" \
      "COPY --from=builder \${DEPENDENCY}/BOOT-INF/classes /app" \
          >>Dockerfile

  #printf '%s\n' 'RUN mkdir /usr/myapp' \
  #       >>Dockerfile

  printf '%s\n' '' \
      "ENV JAVA_OPTS=$MANIFEST_RUN_JAVAOPTS" \
          >>Dockerfile

  #printf '%s\n' '' \
  #    'WORKDIR /usr/myapp' \
  #        >>Dockerfile

  for ports in "${MANIFEST_TYPE_DOCKER_PORTS_ARR[@]}"
  do
      IFS=':' read -ra port <<< "$ports"
      printf '%s\n' \
          "EXPOSE $port" >>Dockerfile
  done
      
  printf '%s\n' '' \
      'ENTRYPOINT ["java","-cp","app:app/lib/*","com.infra.sample.app.Application"]' \
          >>Dockerfile

  if [ $DEBUG -eq 1 ];then
      cat Dockerfile
  fi

  if [[ "$?" -ne 0 ]] ; then
    echo "❌        build failure"; exit 1
  else
    echo "👌       build success"
  fi

  echo "✔️       Build complete"

}
