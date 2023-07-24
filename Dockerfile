# Use the official OpenJDK 17 image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot application JAR file to the container
COPY target/registryserver-0.0.1-SNAPSHOT.jar app.jar

# Expose the port on which your Spring Boot application runs (change 8080 to your application's actual port if needed)
EXPOSE 8761

# Command to run the Spring Boot application when the container starts
CMD ["java", "-jar", "app.jar"]