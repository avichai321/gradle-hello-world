# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.3-jdk11 AS build

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}
# Set the working directory in the container

RUN groupadd -r appuser && useradd -r -g appuser -m -d /home/appuser appuser
WORKDIR /app
#COPY . .
#Copy the Gradle wrapper files and build configuration
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties gradle/ ./gradle/
COPY build.gradle.kts ./
COPY gradlew gradlew.bat ./

#Copy the version file and source code
COPY version.txt ./version.txt
COPY src ./src
# Fix potential line ending issues
RUN sed -i 's/\r$//' ./gradlew
# Ensure gradlew has executable permissions and check if it exists
RUN ls -la && chmod +x ./gradlew && ls -la ./gradlew && echo "Gradlew file info:"



# Run Gradle build
RUN ./gradlew clean build -x test



# Stage 2: Create the runtime image
FROM openjdk:11

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}

WORKDIR /app

# Get the version from the previous build stage
LABEL version="${VERSION}"

COPY --from=build /app/version.txt /app/version.txt
# Copy the built JAR from the build stage
COPY --from=build /app/build/libs/${REPO_NAME}-$(cat /app/version.txt)-all.jar /app/${REPO_NAME}-$(cat /app/version.txt)-all.jar

# Expose port 8080
EXPOSE 8080
USER appuser
# Set the entrypoint to run the versioned JAR file
ENTRYPOINT ["sh", "-c", "java -jar /app/${REPO_NAME}-$(cat /app/version.txt)-all.jar"]