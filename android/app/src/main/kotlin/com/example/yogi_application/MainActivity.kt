package com.example.yogi_application

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

                    val intent = Intent(this, ViewTutorialActivity::class.java)
                    startActivity(intent)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}