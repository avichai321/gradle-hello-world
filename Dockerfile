# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.3-jdk11 AS builder

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}

# Add version argument with empty default
ARG VERSION=""

WORKDIR /app

# Copy Gradle wrapper files and build configuration
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties gradle/ ./gradle/
COPY build.gradle.kts ./
COPY gradlew gradlew.bat ./
COPY src ./src

# Fix potential line ending issues
RUN sed -i 's/\r$//' ./gradlew
RUN chmod +x ./gradlew

# Extract version from file and use external VERSION if provided
RUN FILE_VERSION=$(grep -oP '(?<=version\s*=\s*")[^"]*' build.gradle.kts) && \
    # Use external VERSION if provided, otherwise use FILE_VERSION
    EFFECTIVE_VERSION=${VERSION:-$FILE_VERSION} && \
    echo "Current version: $EFFECTIVE_VERSION" && \
    ./gradlew clean build -x test -Pversion=$EFFECTIVE_VERSION && \
    cd build/libs && \
    ls && \
    mv /app/build/libs/app-${EFFECTIVE_VERSION}-all.jar /app/build/libs/${REPO_NAME}-${EFFECTIVE_VERSION}-all.jar && \
    echo "VERSION=$EFFECTIVE_VERSION" >> /app/version.env

# Stage 2: Create the runtime image
FROM openjdk:11

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}

# Create a non-root user and group
RUN groupadd -r ubuser && useradd -r -g ubuser -m -d /home/ubuser ubuser

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=builder /app/build/libs/ ./libs/
# Copy the version file to extract the variable
COPY --from=builder /app/version.env ./  

# Load the version from the environment file
RUN . /app/version.env && \
    echo "Extracted VERSION: $VERSION"

# Create a startup script that finds the correct JAR
RUN echo '#!/bin/sh' > /app/startup.sh && \
    echo '. /app/version.env' >> /app/startup.sh && \
    echo 'JAR_FILE="/app/libs/${REPO_NAME}-${VERSION}-all.jar"' >> /app/startup.sh && \
    echo 'echo "Starting application: ${JAR_FILE}"' >> /app/startup.sh && \
    echo 'java -jar ${JAR_FILE}' >> /app/startup.sh && \
    chmod +x /app/startup.sh

# Change ownership of the application files to the non-root user
RUN chown -R ubuser:ubuser /app

# Switch to this non-root user
USER ubuser

# Run the startup script
ENTRYPOINT ["/app/startup.sh"]