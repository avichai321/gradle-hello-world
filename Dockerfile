# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.3-jdk11 AS build
# Set the working directory in the container
WORKDIR /app
#COPY . .
#Copy the Gradle wrapper files and build configuration
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties gradle/ ./gradle/
COPY build.gradle.kts ./
COPY gradlew gradlew.bat ./

#Copy the version file and source code
COPY version.txt ./version.txt
COPY src ./src

# Ensure gradlew has executable permissions
RUN chmod +x gradlew && ls -alh

# Read the version from version.txt and pass it as an environment variable
RUN export VERSION=$(cat version.txt) && echo "Building version: $VERSION"

# Run Gradle build
RUN ./gradlew clean build -x test



# Stage 2: Create the runtime image
FROM openjdk:11-jre-slim

WORKDIR /app

# Get the version from the previous build stage
ARG VERSION
LABEL version="${VERSION}"

# Copy the built JAR from the build stage
COPY --from=build /app/build/libs/my-app-${VERSION}-all.jar /app/my-app-${VERSION}-all.jar

# Expose port 8080
EXPOSE 8080

# Set the entrypoint to run the versioned JAR file
ENTRYPOINT ["sh", "-c", "java -jar /app/my-app-$(cat /app/version.txt)-all.jar"]