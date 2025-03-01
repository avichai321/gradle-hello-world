import java.io.File

plugins {
    kotlin("jvm") version "1.6.20"
    id("application")
    id("java")
    id("idea")

    // This is used to create a GraalVM native image
    id("org.graalvm.buildtools.native") version "0.9.11"

    // This creates a fat JAR
    id("com.github.johnrengelman.shadow") version "7.1.2"
}

group = "com.ido"
description = "HelloWorld"
application.mainClass.set("com.ido.HelloWorld")

repositories {
    mavenCentral()
}

val projectVersionFile = file("version.txt")

// Function to read and increment version
fun getNextVersion(): String {
    if (!projectVersionFile.exists()) {
        projectVersionFile.writeText("1.0.0")
    }

    val currentVersion = projectVersionFile.readText().trim()
    val versionParts = currentVersion.split(".").map { it.toInt() }.toMutableList()

    // Increment the patch version
    versionParts[2] = versionParts[2] + 1

    val newVersion = versionParts.joinToString(".")
    projectVersionFile.writeText(newVersion)
    return newVersion
}

// Set the project version dynamically
version = getNextVersion()

// Ensure JAR file name matches repo/directory name
val jarName = rootProject.name

tasks.withType<Jar> {
    archiveBaseName.set(jarName)
    archiveVersion.set(version)
}

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    archiveBaseName.set(jarName)
    archiveVersion.set(version)
}

graalvmNative {
    binaries {
        named("main") {
            imageName.set("helloworld")
            mainClass.set("com.ido.HelloWorld")
            fallback.set(false)
            sharedLibrary.set(false)
            useFatJar.set(true)
            javaLauncher.set(javaToolchains.launcherFor {
                languageVersion.set(JavaLanguageVersion.of(17))
                vendor.set(JvmVendorSpec.matching("GraalVM Community"))
            })
        }
    }
}
