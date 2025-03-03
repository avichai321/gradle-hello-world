# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.3-jdk11 AS builder

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}
# Set the working directory in the container
WORKDIR /app

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
RUN ls -la && chmod +x ./gradlew


# Get version and build using gradlew
RUN VERSION=$(cat version.txt) && \
    echo "Building version: $VERSION" && \
    ./gradlew clean build -x test && \
    cd build/libs && \
    ls && \
    VERSION=$(cat /app/version.txt) &&\
    # Rename the JAR with REPO_NAME
    mv /app/build/libs/app-${VERSION}-all.jar /app/build/libs/${REPO_NAME}-${VERSION}-all.jar


# Stage 2: Create the runtime image
FROM openjdk:11

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}
# Create a non-root user and group
RUN groupadd -r ubuser && useradd -r -g ubuser -m -d /home/ubuser ubuser

WORKDIR /app

COPY --from=builder /app/version.txt /app/version.txt
# Copy the built JAR from the build stage
COPY --from=builder /app/build/libs/ ./libs/


# Create a startup script that finds the correct JAR
RUN echo '#!/bin/sh' > /app/startup.sh && \
    echo 'VERSION=$(cat /app/version.txt)' >> /app/startup.sh && \
    echo 'JAR_FILE="/app/libs/${REPO_NAME}-${VERSION}-all.jar"' >> /app/startup.sh && \
    echo 'echo "Starting application: ${JAR_FILE}"' >> /app/startup.sh && \
    echo 'java -jar ${JAR_FILE}' >> /app/startup.sh && \
    chmod +x /app/startup.sh

# Change ownership of the application files to the non-root user
RUN chown -R ubuser:ubuser /app

# Expose port 8080
EXPOSE 8080

#switch to this non-root user
USER ubuser

# Run the startup script
ENTRYPOINT ["/app/startup.sh"]