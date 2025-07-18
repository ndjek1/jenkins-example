FROM docker.io/maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY server.xml /usr/local/tomcat/conf/server.xml

COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Final stage: Tomcat runtime
FROM tomcat:11.0.8-jdk21-temurin

LABEL maintainer="ndjek"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/container123.war
# Expose HTTP port
EXPOSE 8086
# Run tomcat in foreground
CMD ["catalina.sh", "run"]



