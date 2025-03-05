# Use OpenJDK base image
FROM openjdk:11

# Set a non-root user
ARG USER=ubuseruser
ARG HOME=/home/$USER

# Create a new user and group
RUN useradd -m -d $HOME -s /bin/bash $USER

# Set working directory
WORKDIR /app

# Copy the fat JAR into the container
ARG JAR_FILE=build/libs/*-all.jar
COPY ${JAR_FILE} app.jar

# Change ownership and permissions
RUN chown -R $USER:$USER /app && chmod 755 /app/app.jar

# Switch to the non-root user
USER $USER

# Run the application
CMD ["java", "-jar", "app.jar"]
