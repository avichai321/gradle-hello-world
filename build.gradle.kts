import java.util.Properties

plugins {
    kotlin("jvm") version "1.9.23"
    id("application")
    id("java")
    id("idea")
    // Fat JAR plugin
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

group = "com.ido"
description = "HelloWorld"

// Java toolchain configuration
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(11))
        vendor.set(JvmVendorSpec.ADOPTIUM)
    }
}

application {
    mainClass.set("com.ido.HelloWorld")
}

repositories {
    mavenCentral()
}

// Version Management
val propertiesFile = file("gradle.properties")
val properties = Properties()

if (propertiesFile.exists()) {
    propertiesFile.reader().use { properties.load(it) }
} else {
    properties["project.version"] = "1.0.0"
    propertiesFile.writer().use { properties.store(it, null) }
}

val currentVersion = properties.getProperty("project.version", "1.0.0")
version = currentVersion

// Get the repository name (assuming the project directory name)
val repoName = rootProject.name.lowercase()

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    archiveBaseName.set(repoName)
    archiveVersion.set(project.version.toString())
    archiveClassifier.set("all")
}

// Docker build task
tasks.register("buildDocker") {
    group = "docker"
    description = "Builds a Docker image for the project"
    
    dependsOn("shadowJar")
    
    doLast {
        val jarFile = file("build/libs/${repoName}-${project.version}-all.jar")
        
        // Use ProcessBuilder for executing Docker commands
        ProcessBuilder(
            "docker", "build", 
            "-t", "${repoName}:${project.version}",
            "-t", "${repoName}:latest",
            "--build-arg", "JAR_FILE=${jarFile.name}",
            "."
        )
        .inheritIO()
        .start()
        .waitFor()
    }
}