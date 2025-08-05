// Top-level build.gradle.kts


buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
    }
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Set custom build directory location
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// ✅ Configure each subproject to use the same build directory structure
subprojects {
    project.layout.buildDirectory.set(newBuildDir.dir(project.name))
    evaluationDependsOn(":app")
}

// ✅ Register a clean task to delete the custom build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
