# Use OpenJDK slim base image
FROM openjdk:11-jre-slim

# Set arguments
ARG USER=ubuser
ARG HOME=/home/$USER
ARG JAR_FILE

# Create a new user and group
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --home $HOME $USER

# Set working directory
WORKDIR /app

# Copy the fat JAR into the container
COPY build/libs/${JAR_FILE} gradle_app.jar.jar

# Change ownership and permissions
RUN chown -R $USER:appgroup gradle_app.jar && \
    chmod 755 gradle_app.jar

# Switch to the non-root user
USER $USER

# Expose port if your application uses one (optional)
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "gradle_app.jar"]