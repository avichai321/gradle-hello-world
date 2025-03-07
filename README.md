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

the Gradle Wrapper will build you the Docker image as well

# Pipeline Build roadmap
* update_version_local_repo - who increase the version project variable and update him on github repo because the docker file run on himself and cant` update out file
   1. checkout - first it will check the pipeline code before run
   2. Extract current version - extract the current version from the build.gradle.kts
   3. Calculate new version - calculate the updated version property in the build.gradle.kts file by 1
   4. Update version in build.gradle.kts - save the new version property in the build.gradle.kts file by 1
   5. Commit and push changes - commit and push the changes to the git repo
* build-and-deploy - the stage build the multistage Docker, push it to Docker hub pull him and check container
   1. checkout - first it will check the pipeline code before run
   2. Set up JDK for the APP - set the java environment for the app
   3. Build with Gradle - build the gradle up with the updated version
   4. Build Docker Image with Updated Version and tag it - create the docker build operation and gave him the updated tag he needs
   5. Login to Docker Hub - login to docker hub with user and password (secret)
   6. Push Docker Image with Updated Version - tag the Docker and upload it
   7. Pull updated image from Docker hub and run - Pull the Docker from Docker hub and run it


# Dockerfile
Is a simple Docker file who copy the artifact set him on openjdk:11 environment and dockerize him as image


# Important information
1. The gradle Wrapper here use gradle:8.13.
2. The project is set to use java 11 to avoid dependencies issues.
3. Gradle.properties file held the version of the jar was created in the last build
4. In this branch 1.0.0 versions style
