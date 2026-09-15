allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val fixNamespace: Project.() -> Unit = {
        val android = extensions.findByName("android")
        if (android != null) {
            try {
                val namespaceMethod = android.javaClass.getMethod("getNamespace")
                val currentNamespace = namespaceMethod.invoke(android)
                if (currentNamespace == null || (currentNamespace as? String).isNullOrEmpty()) {
                    val setNamespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                    val projectGroup = group.toString()
                    val targetNamespace = if (projectGroup.isNotEmpty() && projectGroup != "null" && projectGroup != "unspecified") {
                        projectGroup
                    } else {
                        "com.example.${name.replace("-", "_").replace(":", "_")}"
                    }
                    setNamespaceMethod.invoke(android, targetNamespace)
                }
            } catch (_: Exception) {
            }
        }
    }

    if (state.executed) {
        fixNamespace()
    } else {
        afterEvaluate {
            fixNamespace()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
