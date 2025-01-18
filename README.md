# getnet_payments

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



    //INICIO - Deve ser inserido esse metodo dentro do android{}
    signingConfigs {
        config {
            v1SigningEnabled true
            v2SigningEnabled true
        }
    }
    //FIM - Deve ser inserido esse metodo dentro do android{}

    buildTypes {
        debug {
            debuggable true
            testCoverageEnabled true
            signingConfig signingConfigs.config //Deve ser inserida essa linha no buildTypes
            crunchPngs false
        }
        release {
            minifyEnabled false
            debuggable false
            signingConfig signingConfigs.config //Deve ser inserida essa linha no buildTypes
            proguardFiles getDefaultProguardFile('proguard-android.txt','proguard-rules.pro')
            crunchPngs true
        }
    }



    AndroidManifest.xml
    <application
        android:launchMode="singleTask"
        android:alwaysRetainTaskState="true"
        ...></application>