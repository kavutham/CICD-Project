FROM openjdk:17
ARG JAR_FILE
RUN yum update
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
