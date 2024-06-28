package com.example.yogi_application

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.activity.viewModels
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.example.yogi_application.databinding.ActivityMainBinding
import com.example.yogi_application.model.Exercise

class ExerciseActivity : AppCompatActivity() {
    private lateinit var activityMainBinding: ActivityMainBinding
    private val viewModel : MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Access the SharedPreferences
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Retrieve the tokens using the same keys but prefixed with "flutter."
        val accessToken = prefs.getString("flutter.accessToken", "default_value")
        val exerciseString = prefs.getString("flutter.exercise", "")
        val exercise = exerciseString?.let { Exercise.fromJson(it) };

        activityMainBinding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(activityMainBinding.root)

        val navHostFragment =
            supportFragmentManager.findFragmentById(R.id.fragment_container) as NavHostFragment
        val navController = navHostFragment.navController
        activityMainBinding.navigation.setupWithNavController(navController)
        activityMainBinding.navigation.setOnNavigationItemReselectedListener {
            // ignore the reselection
        }

        val scoreFragment = supportFragmentManager.findFragmentById(R.id.fragment_score)

    }

    override fun onResume() {
        super.onResume()
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_FULLSCREEN
        getSupportActionBar()?.hide()
    }
    

    override fun onBackPressed() {
        finish()
    }
}