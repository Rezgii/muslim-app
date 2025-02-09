# Preserve generic type signatures
-keepattributes Signature
-keepattributes *Annotation*

# Keep classes that use Gson (or other serialization libraries)
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * implements com.google.gson.reflect.TypeToken { *; }

# Keep all classes in your package (adjust the package name)
-keep class com.RzRio.muslim.** { *; }