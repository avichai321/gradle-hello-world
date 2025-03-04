import java.util.Properties

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

// Define the properties file and load properties
val propertiesFile = file("gradle.properties")
val properties = Properties()

// Load properties from the file if it exists, else create a default one
if (propertiesFile.exists()) {
    propertiesFile.reader().use { properties.load(it) }
} else {
    // Create gradle.properties and add the default version if it doesn't exist
    properties["project.version"] = "1.0.0"
    propertiesFile.writer().use { properties.store(it, null) }
}

// Function to increment version automatically
fun incrementVersion(version: String): String {
    val versionParts = version.split(".").map { it.toInt() }.toMutableList()

    // Increment the patch version
    versionParts[2] = versionParts[2] + 1

    return versionParts.joinToString(".")
}

// Get the current version from gradle.properties
var currentVersion = properties.getProperty("project.version", "1.0.0")

// Increment version for next build
currentVersion = incrementVersion(currentVersion)

// Update gradle.properties with the new version
properties["project.version"] = currentVersion
propertiesFile.writer().use { properties.store(it, null) }

// Set the project version dynamically
version = currentVersion

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
