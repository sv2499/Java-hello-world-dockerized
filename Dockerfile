# Stage 1: Maven build container
FROM maven:3.8.5-openjdk-11 AS maven_build
WORKDIR /app
COPY pom.xml . 
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Runtime container
FROM eclipse-temurin:11-jre-alpine
WORKDIR /app
COPY --from=maven_build /app/target/*.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
