package com.example.yogi_application

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yogitech" // Define channel name as a constant

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // No need for GeneratedPluginRegistrant if you're not using plugins

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "exerciseActivity" -> {
                    val intent = Intent(this, ExerciseActivity::class.java)
                    startActivity(intent)
                    result.success("Activity started") // More informative success message
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}