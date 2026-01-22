# -------- Build stage --------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN C:\tools\apache-maven-3.9.12\bin\mvn.cmd -B dependency:go-offline
COPY src ./src
RUN C:\tools\apache-maven-3.9.12\bin\mvn.cmd -B package -DskipTests

# -------- Runtime stage --------
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /springboot_maven/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]