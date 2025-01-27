# Stage 1: Maven build container
FROM maven:3.8.5-openjdk-11 AS maven_build
WORKDIR /app
# Copy only pom.xml and download dependencies to leverage caching
COPY pom.xml . 
RUN mvn dependency:go-offline -B
# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Runtime container
FROM eclipse-temurin:11-jre-alpine
WORKDIR /app
# Copy the built JAR file from the build stage
COPY --from=maven_build /app/target/*.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
