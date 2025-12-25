FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy the JAR file (created by Maven package)
COPY target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
