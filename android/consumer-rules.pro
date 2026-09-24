# Regras aplicadas ao app que consome o plugin (build release com R8).

# SDK Getnet
-keep class com.libposdigital.** { *; }

# Models serializados/desserializados via Gson (reflexão).
# Sem isso o R8 remove construtores/renomeia campos e o Gson falha com
# "Abstract classes can't be instantiated" ou gera JSON com chaves ofuscadas.
-keep class br.com.joelabs.getnet_payments.models.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod,InnerClasses
-dontwarn sun.misc.**
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
