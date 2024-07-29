package com.example.yogi_application

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.Observer
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.example.yogi_application.databinding.ActivityMainBinding
import com.example.yogi_application.fragment.CustomDialogFragment
import com.example.yogi_application.model.Exercise
import com.example.yogi_application.model.ExerciseFeedback
import com.example.yogi_application.network.FeedbackApiService
import com.example.yogi_application.network.ServiceBuilder
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.Locale

class ExerciseActivity : AppCompatActivity() {
    private lateinit var activityMainBinding: ActivityMainBinding
    private val viewModel : MainViewModel by viewModels()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Access the SharedPreferences
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        // Retrieve the tokens using the same keys but prefixed with "flutter."
        val accessToken = prefs.getString("flutter.accessToken", "default_value")
        val locale = prefs.getString("flutter.locale", "vi")
        if (locale != null) {
            setLocale(this, locale)
        };
        val flutterEngine = (application as YogiApplication).flutterEngine
        viewModel.flutterEngine =flutterEngine

        activityMainBinding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(activityMainBinding.root)



        ServiceBuilder.setToken(accessToken)


        val navHostFragment =
            supportFragmentManager.findFragmentById(R.id.fragment_container) as NavHostFragment
        val navController = navHostFragment.navController
//        activityMainBinding.navigation.setupWithNavController(navController)
//        activityMainBinding.navigation.setOnNavigationItemReselectedListener {
//            // ignore the reselection
//        }

        val dialog = CustomDialogFragment()
        viewModel.pauseCamera.observe(this, Observer { shouldPause ->
            if (shouldPause) {
                dialog.show(supportFragmentManager, "CustomDialog")
            } else {
                dialog.dismiss()
            }
        })
        val scoreFragment = supportFragmentManager.findFragmentById(R.id.fragment_score)

    }

    override fun onResume() {
        super.onResume()
        window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_FULLSCREEN
                or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
        supportActionBar?.hide()
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
        }
    }


    override fun onBackPressed() {
        finish()
    }

    private fun setLocale(context: Context, language: String) {
        val locale = Locale(language)
        Locale.setDefault(locale)
        val resources = context.resources
        val configuration = resources.configuration
        configuration.setLocale(locale)
        resources.updateConfiguration(configuration, resources.displayMetrics)
    }
}