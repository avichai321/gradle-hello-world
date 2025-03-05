# gradle-hello-world

# Java Hello World using the Gradle Wrapper and the Kotlin DSL
This is a Hello World project that contains the most important parts of the Gradle build scripts.

# Tasks
```
build - Compiles Hello World and creates JAR files.
2 jar files will be created:
- gradle-hello-world-all.jar - this jar contains everything.
- gradle-hello-world.jar - this is regular jar, it contains only the project's classes.
```

# Build
```
./gradlew build
The jar files located ar gradle-hello-world/build/libs/
make the runnable jar executable then, use "java -jar gradle-hello-world-all.jar"
```

# Devops_Exercise-gradle-hello-world
# Branch - task3-test-with-use-gradle-only Overview
In this Branch i did the tasks number 1 and 2 who asks us to create a pipeline to the following actions
- task 1
    1. Build the Project as is and answer 3 q
        * which language the project use 
        * what is gradle and how he works 
        * what is gradle Wrapper
- task 2
    1. Bulid the project with pipeline but we need 2 things
        * set the jar version to 1.0.0
        * add my name to java code hello world message

# Questions answers
 1. If the question mean to the project language so its java but if we look on the build.gradle.kts the program language we use there is kotlin DSL 
 2. Gradle is a tool who helps us to deploy project with tasks we create in the gradle.build.kts after that we wrote the command "gradlew build" (if thats the task we want operate) and the task will happen
 3. gradle wrapper is a file who gave as the opportunity to choose the gradle program to the project and we even not need to install gradle in our computer (very helpful i must say)
 4. The rest of things will happen face to face

# pipeline roadmap
The pipeline is builded from 2 tasks:
- Task_1_build_program_as_is - for task 1
    1. checkout - first it wiil check the pipeline code before run
    2. Set up JDK for the APP - set the java environment for the app
    3. Use Gradle wrapper as executable and Build the Program with Gradle - Build the gradle project
    4. Check jar file version and run java - check the results

- Task_2_change_code_and_change_ver_first
    1. Update Hello World to Hello World Avicii - change the "Hello World" message
    2. Use Gradle wrapper as executable and Build the Program with Gradle - Build the gradle project and set the version property as 1.0.0
    3. Check jar file version and run java - check the results

 # Other branches with Tasks
 task4 - the bonus Multistage Docker 
 task3-test-use-gradle-only - build project and Docker image with Gradle