# Saved
FROM adoptopenjdk/openjdk11

RUN mkdir /usr/myapp

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS

COPY ./target/sample-app-0.0.1-SNAPSHOT.jar /usr/myapp/app.jar

WORKDIR /usr/myapp
EXPOSE 9010
EXPOSE  9011

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]
