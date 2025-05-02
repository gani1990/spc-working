FROM maven:3.9-eclipse-temurin-17 AS build
COPY . /spc
WORKDIR /spc
RUN mvn package


FROM gcr.io/distroless/java17-debian12
LABEL project="learning" 
LABEL author="khaja"
COPY --from=build  --chown=${USERNAME}:${USERNAME}  /spc/target/spring-petclinic-3.4.0-SNAPSHOT.jar /apps/spring-petclinic-3.4.0-SNAPSHOT.jar
WORKDIR /apps
EXPOSE 8080
# CMD Executes when the container is started
CMD [ "java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar" ]
