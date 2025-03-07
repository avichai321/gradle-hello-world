# gradle-hello-world
# Devops_Exercise-gradle-hello-world
# Branch - task4
In this Branch i did the task number in 5 bonus who asks us to create a pipeline to the following actions with multistage Docker
 1. Version Handling - the Version of the jar file who complies increasing by 1 Every build (gradle build)
 2. Build Artifact - Build java artifact and package him (gradle build in Multistage Docker)
 3. Make a Docker image from Him (Multistage Docker) 
 4. upload him to Docker Hub (pipeline)

# Build With the branch in your own computer
 1. install java on your computer before you Start
 2. get into of the folder repo you Downloaded
 3. ```docker build -t my-app:latest . ```(this because the docker file purpose is for the github-actions and in the pipeline he take the name and the tag)  



# pipeline roadmap
 in this pipeline we have 3 jobs who each one need the last job will finish and then he will start 
 * update_version_local_repo - who increase the version project variable and because the docker file run on himself and cant` update out file
    1. checkout - first it will check the pipeline code before run 
    2. Increment Version in gradle.properties - update the version in the gradle.properties file by 1
    3. Commit and Push Version Update - commit it and push to github repository that the version file with the next version
 * Docker build - build the multistage docker 
    1. Checkout Repository - (Updated Version)
    2. Fetch Updated Version - export the version that we need to use as docker tag at the end of the pipeline
    3. Build Docker Image with Updated Version - operate the multistage docker and gave him the updated tag he needs
    4. Save Docker Image - save the docker image as artifact that i can upload
    5. Upload Docker Image as Artifact - use the option of github to upload the artifact to them and in the next job in the workflow i will use it 
 * Push_Docker_to_Docker_HUB - At last Update to Docker hub
    1. Checkout Repository - (Ensure Latest)
    2. Download Docker Image Artifact - Download the artifact we save at last stage
    3. Load Docker Image - load the docker from the tar
    4. Fetch Updated Version - export and save the right tag he needs 
    5. Login to Docker Hub - login to docker hub with user and password (secret)
    6. Tag and Push Docker Image with Updated Version - tag the Docker and upload it 

# multistage Docker
the multistage Docker is build with 2 stages
* stage 1 - copy all the files he need build the jar artifact with gradle
* stage 2 - create the runtime image and docker image that can run with non root user 


# Important information
    1. The gradle Wrapper here use gradle:7.4.2
    2. Gradle.properties file held the version of the jar was created in the last build
    3. I use 2.1.0 version style in this branch