# gradle-hello-world
# Devops_Exercise-gradle-hello-world
# Branch - task4
In this Branch i did the task number in 5 bonus who asks us to create a pipeline to the following actions with multistage Docker
 1. Version Handling - the Version of the jar file who complies increasing by 1 Every build (pipeline)
 2. Build Artifact - Build java artifact and package him (gradle build in Multistage Docker)
 3. Make a Docker image from Him (Multistage Docker) 
 4. upload him to Docker Hub (pipeline)
 5. pull and run from Docker Hub

# Build With the branch in your own computer
 1. install java on your computer before you Start
 2. get into of the folder repo you Downloaded
 3. ```docker build -t my-app:latest . ```(this because the docker file purpose is for the github-actions and there in the pipeline he takes the name and the tag)  



# pipeline roadmap
 in this pipeline we have 1 job who fo the following things 
 * update_version_local_repo - who increase the version project variable and because the docker file run on himself and cant` update out file
    1. checkout - first it will check the pipeline code before run 
    2. Increment Version in build.gradle.kts - update the version property in the build.gradle.kts file by 1
    3. Build Docker Image with Updated Version - operate the multistage docker and gave him the updated tag he needs
    4. Login to Docker Hub - login to docker hub with user and password (secret)
    5. Tag and Push Docker Image with Updated Version - tag the Docker and upload it 
    6. Pull updated image from Docker hub and run - Pull the Docker from Docker hub and run it
# multistage Docker
the multistage Docker is build with 2 stages
* stage 1 - copy all the files he need build the jar artifact with gradle
* stage 2 - create the runtime image and docker image that can run with non root user 


# Important information
    1. The gradle Wrapper here use gradle:7.4.2
    2. build.gradle.kts file held the version of the jar was created in the last build
    3. I use here in 1.1.0 version and in task 3 i use 1.0.0 to not ruin the other branch who use this type of version that Both of them can upload to the Docker hub and be regognized simultaneously and we can see the changes in Docker hub