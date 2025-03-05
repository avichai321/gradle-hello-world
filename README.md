# gradle-hello-world
# Devops_Exercise-gradle-hello-world
# Branch - task3-test-with-use-gradle-only Overview
In this Branch i did the task number in 5 who asks us to create a pipeline to the following actions
1. Version Handling -  the Version of the jar file who complies increasing by 1 Every build (gradle build)
2. Build Artifact - Build java artifact and package him (gradle build)
4. Make a Docker image from Him and upload him to Docker Hub

# Build With the branch in your own computer
-  install java 11 on your computer before you Start
-  get in to the folder repo you Downloaded
-  run ./gradlew build

the Gradle Wrapper will build you the Docker im age as well

# Pipeline Build roadmap
1. checkout - first it wiil check the pipeline code before run
2. Set up JDK for the APP - set the java environment for the app
3. Use Gradle wrapper as executable and Build the Program with Gradle - Build the gradle project
4. Check jar file version and docker after build - Check if the jar files and the Docker images created
5. Fetch Updated Version after build - take the version number who updated in the file gradle.properties and make us a variable with tag to make sure we use the right version
6. Commit and Push Version Update - because we did changes in the gradle.properties we want him to to update the git repo as well so he commit and push the changes
7. Login to Docker Hub - login with user and token
8. Tag and Push Docker Image with Updated Version - get the image frm the environment variable we save in task 5. tag him on the image and upload him to docker hub


# Dockerfile
Is a simple Docker file who copy the artifact set him on openjdk:11 environment and dockerize him as image


# Important information
1. The gradle Wrapper here use gradle:8.13.
2. The project is set to use java 11 to avoid dependencies issues.
3. Gradle.properties file held the version of the jar was created in the last build
4. I use 2.0.0 instead 1.0.0 to not ruin task 4 branch who use this type of version that Both of them can uploaded to the Docker hub simultaneously
