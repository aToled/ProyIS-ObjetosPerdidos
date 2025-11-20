import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Lee el archivo local.properties para obtener la clave de Maps
val properties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    // Sintaxis de Kotlin para leer el archivo
    properties.load(localPropertiesFile.reader(Charsets.UTF_8))
} else {
    // En caso de que el archivo no exista
    throw GradleException("Falta local.properties. Asegúrate de crear uno y añadir 'MAPS_API_KEY=TU_CLAVE'")
}

val mapsApiKey = properties.getProperty("MAPS_API_KEY")
if (mapsApiKey == null) {
    throw GradleException("Falta 'MAPS_API_KEY' en local.properties.")
}

android {
    namespace = "com.example.app_objetos_perdidos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    // ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.app_objetos_perdidos"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Esta línea (Paso 4) está perfecta aquí
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

configurations.all {
    resolutionStrategy {
        eachDependency {
            if (requested.group == "androidx.core" && !requested.name.contains("androidx")) {
                useVersion("1.15.0")
            }
        }
    }
}
