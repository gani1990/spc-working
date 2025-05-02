FROM eclipse-temurin:17
LABEL project="learning" 
LABEL author="khaja"
ARG USERNAME=spc
RUN useradd -m -d /apps -s /bin/sh ${USERNAME}
USER ${USERNAME}
COPY --chown=${USERNAME}:${USERNAME}  target/spring-petclinic-3.4.0-SNAPSHOT.jar /apps/spring-petclinic-3.4.0-SNAPSHOT.jar
WORKDIR /apps
EXPOSE 8080
# CMD Executes when the container is started
CMD [ "java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar" ]
