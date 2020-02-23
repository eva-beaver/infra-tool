#!/usr/bin/env bash

readonly XXX="Fred"  

echo $XXX

    printf '%s\n' "# Generated $(date)" \
        "FROM $XXX " \
        'RUN mkdir /usr/myapp' \
        'COPY ./target/micrometer-prometheus-0.0.1-SNAPSHOT.jar /usr/myapp/app.jar' \
        'WORKDIR /usr/myapp' \
        "EXPOSE 8080" \
        'ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar"' \
        '' >df   
