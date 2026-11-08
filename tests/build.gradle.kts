// Tests unitaires du module d'aide (helper/src), sur la JVM : gradle -p tests test
// Le module est compilé contre le framework Android 9 (API 28, celui de la voiture) publié
// par Robolectric sur Maven Central ; les classes de la radio SAIC sont simulées dans les tests.
plugins { java }

repositories { mavenCentral() }

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

sourceSets {
    main { java.setSrcDirs(listOf("../helper/src")) }
}

val androidAll = "org.robolectric:android-all:9-robolectric-4913185-2"

dependencies {
    compileOnly(androidAll)
    testImplementation(androidAll)
    testImplementation("junit:junit:4.13.2")
}

tasks.withType<JavaCompile>().configureEach {
    options.encoding = "UTF-8"
    options.compilerArgs.add("-Xlint:-options")
}

tasks.test {
    // Les tests de contrat lisent le smali et les ressources : les relancer quand ils changent
    inputs.dir("../dash").withPropertyName("dash")
    inputs.file("../VERSION").withPropertyName("version")
    testLogging {
        events("failed")
        exceptionFormat = org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
    }
}
