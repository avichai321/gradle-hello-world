# Stage 1: Build the JAR file using Gradle Wrapper
FROM gradle:7.4-jdk11 AS builder

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}
# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper files and build configuration
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/gradle-wrapper.properties gradle/ ./gradle/
# Ensure this is your updated build.gradle.kts
COPY build.gradle.kts ./  
# Copy gradle wrapper scripts
COPY gradlew gradlew.bat ./ 


# Copy the source code
COPY src ./src
# Fix potential line ending issues
RUN sed -i 's/\r$//' ./gradlew

# Ensure gradlew has executable permissions and check if it exists
RUN ls -la && chmod +x ./gradlew

# Ensure repositories are accessible and build the JAR
RUN ./gradlew clean build -x test

# Extract version from gradle.properties and rename JAR
RUN VERSION=$(grep -oP '(?<=project.version=)[^\r]+' gradle.properties) && \
    mv /app/build/libs/${REPO_NAME}-${VERSION}-all.jar /app/build/libs/${REPO_NAME}-${VERSION}-all.jar

# Stage 2: Create the runtime image
FROM openjdk:11

ARG REPO_NAME=my-app
ENV REPO_NAME=${REPO_NAME}
# Create a non-root user and group
RUN groupadd -r ubuser && useradd -r -g ubuser -m -d /home/ubuser ubuser

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=builder /app/build/libs/ ./libs/

# Create a startup script that finds the correct JAR
RUN echo '#!/bin/sh' > /app/startup.sh && \
    echo 'JAR_FILE="/app/libs/${REPO_NAME}-${VERSION}-all.jar"' >> /app/startup.sh && \
    echo 'echo "Starting application: ${JAR_FILE}"' >> /app/startup.sh && \
    echo 'java -jar ${JAR_FILE}' >> /app/startup.sh && \
    chmod +x /app/startup.sh

# Change ownership of the application files to the non-root user
RUN chown -R ubuser:ubuser /app

# Expose port 8080
EXPOSE 8080

# Switch to this non-root user
USER ubuser

# Run the startup script
ENTRYPOINT ["/app/startup.sh"]
