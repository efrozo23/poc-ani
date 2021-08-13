#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package -Ddocker.skip.build=true -Ddocker.skip=true -DSkipTests

#
# Package stage
#
FROM fabric8/s2i-java:2.3
USER root 
RUN mkdir /usr/local/lib/log
COPY --from=build /home/app/target/*.jar /usr/local/lib/demo.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar"]