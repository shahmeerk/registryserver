#java version
FROM openjdk:17-jdk-slim
#set the working directory inside container
WORKDIR /app
#copy application JAR file to the container
COPY target/registryserver-0.0.1-SNAPSHOT.jar app.jar
#Expose port application runs on
EXPOSE 8761
#run application when container starts
CMD ["java", "-jar", "app.jar"]