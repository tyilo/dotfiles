import com.github.benmanes.gradle.versions.updates.DependencyUpdatesTask

initscript {
  repositories {
    gradlePluginPortal()
  }
  dependencies {
    classpath("com.github.ben-manes:gradle-versions-plugin:+")
  }
}

allprojects {
  apply<com.github.benmanes.gradle.versions.VersionsPlugin>()

  tasks.named<DependencyUpdatesTask>("dependencyUpdates").configure {
    rejectVersionIf {
      isNonStable(candidate.version)
    }
  }
}

// See https://discuss.gradle.org/t/handling-touppercase-uppercase-in-init-d-scripts-in-different-gradle-and-kotlin-version/46611
@Suppress("PLATFORM_CLASS_MAPPED_TO_KOTLIN")
fun String.uppercase(): String = (this as java.lang.String).toUpperCase()

fun isNonStable(version: String): Boolean {
    val stableKeyword = listOf("RELEASE", "FINAL", "GA").any { version.uppercase().contains(it) }
    val regex = "^[0-9,.v-]+(-r)?$".toRegex()
    val isStable = stableKeyword || regex.matches(version)
    return isStable.not()
}
