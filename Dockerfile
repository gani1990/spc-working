# Use a minimal Java runtime base image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built jar from the local target folder to the container
COPY target/*.jar spring-petclinic-3.4.0-SNAPSHOT.jar

# Expose the port your app runs on (optional but recommended)
EXPOSE 8088

# Run the jar file
ENTRYPOINT ["java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar"]
