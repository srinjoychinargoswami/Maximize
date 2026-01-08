# Keep all flutter_local_notifications classes (plugin uses reflection)
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep your model classes - adjust package name if different
-keep class com.example.maximize.models.** { *; }

# Keep all Drift/Moor database classes (critical for your database)
-keep class drift.** { *; }
-keep class moor.** { *; }
-keep class com.simolus.drift.** { *; }

# Keep SQLite classes
-keep class io.flutter.plugins.sqlite.** { *; }
-keep class androidx.sqlite.** { *; }

# Keep shared_preferences plugin classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep path_provider plugin classes
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep UUID classes (since you use UUID generation)
-keep class java.util.UUID { *; }

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Gson (or similar) reflection needs these attributes kept
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# If you use Gson for serialization, keep model fields
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep JSON annotation classes (for your models)
-keep class com.google.gson.annotations.** { *; }
-keep class org.json.** { *; }

# Keep all enum classes (often used in models)
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# For Android support libraries or AndroidX (keep as per standard)
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# Keep Play Core splitcompat classes
-keep class com.google.android.play.core.splitcompat.** { *; }


# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep classes with main methods
-keepclasseswithmembers class * {
    public static void main(java.lang.String[]);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# If using reflection for database operations
-keepclassmembers class * {
    @androidx.room.** <methods>;
    @drift.** <methods>;
}

# Prevent obfuscation of your app's entry points
-keep class com.example.maximize.MainActivity { *; }
-keep class com.example.maximize.MainApplication { *; }

# Additional Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Don't warn about missing classes from other platforms
-dontwarn io.flutter.embedding.**
