FROM openjdk:11-jre-slim

# Set arguments
ARG USER=appuser
ARG HOME=/home/$USER

# Create a new user and group
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --home $HOME $USER

# Set working directory
WORKDIR /app

# Copy the fat JAR (the one ending with -all) into the container
COPY build/libs/*-all.jar app.jar

# Change ownership and permissions
RUN chown -R $USER:appgroup app.jar && \
    chmod 755 app.jar

# Switch to the non-root user
USER $USER

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]