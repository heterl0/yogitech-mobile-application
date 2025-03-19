-keep class okhttp3.internal.platform.** { *; }
-keep class com.google.mediapipe.proto.** { *; }
-keepclassmembers class * extends com.google.protobuf.GeneratedMessageLite { *; }
-keep class com.google.common.flogger.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

-keep,allowobfuscation,allowshrinking interface retrofit2.Call 
-keep,allowobfuscation,allowshrinking class retrofit2.Response 
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation 

 # Rule to save runtime annotations on serializable class.
# If the R8 full mode is used, annotations are removed from classes-files.
#
# For the annotation serializer, it is necessary to read the `Serializable` annotation inside the serializer<T>() function - if it is present,
# then `SealedClassSerializer` is used, if absent, then `PolymorphicSerializer'.
#
# When using R8 full mode, all interfaces will be serialized using `PolymorphicSerializer`.
#
# see https://github.com/Kotlin/kotlinx.serialization/issues/2050

 -if @kotlinx.serialization.Serializable class **
 -keep, allowshrinking, allowoptimization, allowobfuscation, allowaccessmodification class <1>


# Rule to save INSTANCE field and serializer function for Kotlin serializable objects.
#
# R8 full mode works differently if the instance is not explicitly accessed in the code.
#
# see https://github.com/Kotlin/kotlinx.serialization/issues/2861
# see https://issuetracker.google.com/issues/379996140

-keepclassmembers @kotlinx.serialization.Serializable class ** {
    public static ** INSTANCE;
    kotlinx.serialization.KSerializer serializer(...);
}

-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# OkHttp3: https://github.com/square/okhttp/blob/master/okhttp/src/main/resources/META-INF/proguard/okhttp3.pro
## JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**
## A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
## Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*
## OkHttp platform used only on JVM and when Conscrypt dependency is available.
-dontwarn okhttp3.internal.platform.ConscryptPlatform

-dontwarn javax.lang.model.SourceVersion
-dontwarn javax.lang.model.element.Element
-dontwarn javax.lang.model.element.ElementKind
-dontwarn javax.lang.model.type.TypeMirror
-dontwarn javax.lang.model.type.TypeVisitor
-dontwarn javax.lang.model.util.SimpleTypeVisitor8
-dontwarn okhttp3.internal.platform.**


# Keep annotations and attributes needed for serialization
-keepattributes *Annotation*
-keepattributes Signature

# Keep your model classes
-keep class com.yogitech.yogi_application.model.** { *; }

# Keep kotlinx.serialization classes
-keep class kotlinx.serialization.** { *; }

# Keep ViewModel and LiveData related classes
-keep class androidx.lifecycle.** { *; }

# Keep dynamically retrieved string resources
-keepclassmembers class * {
    @androidx.annotation.StringRes <fields>;
}

# Keep all enums if necessary
-keep class com.yogitech.yogi_application.** { *; }
-keepclassmembers class **.R$* { *; }