# Stage 1: Build JAR
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /sprintboot_maven

# Copy Maven config first to cache dependencies
COPY pom.xml .
RUN mvn -B -q dependency:resolve dependency:resolve-plugins \
    -Dmaven.wagon.http.retryHandler.count=5 \
    -Dmaven.wagon.http.pool=false

# Copy source code
COPY src ./src

# Build JAR
RUN mvn clean package -DskipTests

# Stage 2: Runtime image
FROM eclipse-temurin:17-jre

WORKDIR /sprintboot_maven

# Copy built JAR from build stage
COPY --from=build /sprintboot_maven/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
