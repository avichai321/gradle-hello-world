# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.3-jdk11 AS builder

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}

WORKDIR /app

# Copy Gradle wrapper files and build configuration
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties gradle/ ./gradle/
COPY build.gradle.kts ./
COPY gradlew gradlew.bat ./
COPY src ./src

# Fix potential line ending issues
RUN sed -i 's/\r$//' ./gradlew
RUN chmod +x ./gradlew

# Extract version and pass it via ARG
ARG VERSION
RUN VERSION=$(grep -oP 'version\s*=\s*"\K[^"]*' build.gradle.kts) && \
    echo "Current version: $VERSION" && \
    ./gradlew clean build -x test && \
    cd build/libs && \
    ls && \
    # Rename the JAR with REPO_NAME
    mv /app/build/libs/app-${VERSION}-all.jar /app/build/libs/${REPO_NAME}-${VERSION}-all.jar && \
    echo "VERSION=$VERSION" >> /app/version.env

# Stage 2: Create the runtime image
FROM openjdk:11

ARG REPO_NAME=my-app
ARG VERSION  # Pass VERSION explicitly again
ENV REPO_NAME=${REPO_NAME}
ENV VERSION=${VERSION}

# Create a non-root user and group
RUN groupadd -r ubuser && useradd -r -g ubuser -m -d /home/ubuser ubuser

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=builder /app/build/libs/ ./libs/
# Copy the version file to extract the variable
COPY --from=builder /app/version.env ./  

# Load the version from the environment file
RUN export $(cat /app/version.env | xargs) && \
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
