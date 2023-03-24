FROM openjdk:17-jdk-slim-buster
VOLUME /tmp

COPY build/libs/*.jar app.jar

ENTRYPOINT java -jar app.jar