package com.example.yogi_application

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import com.example.yogi_application.model.ExerciseLog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yogitech" // Define channel name as a constant
//    private val viewModel: MainViewModel by viewModels();
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        (application as YogiApplication).flutterEngine = flutterEngine
        // No need for GeneratedPluginRegistrant if you're not using plugins

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "exerciseActivity" -> {
//                    val intent = Intent(this, ExerciseActivity::class.java)
//                    startActivityForResult(intent, 0)
//                    result.success("Activity started") // More informative success message
                    val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

                    // Retrieve the tokens using the same keys but prefixed with "flutter."
                    val isHidden = prefs.getBoolean("flutter.hideTutorial", false)
                    if (isHidden) {
                        val intent = Intent(this, ExerciseActivity::class.java)
                        startActivity(intent)
                    } else {
                        val intent = Intent(this, ViewTutorialActivity::class.java)
                        startActivity(intent)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}