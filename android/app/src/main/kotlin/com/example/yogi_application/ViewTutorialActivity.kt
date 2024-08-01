package com.example.yogi_application

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.Button
import android.widget.VideoView
import androidx.appcompat.app.AppCompatActivity
import java.util.Locale

class ViewTutorialActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Access the SharedPreferences
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val locale = prefs.getString("flutter.locale", "vi")
        if (locale != null) {
            setLocale(this, locale)
        };
        setContentView(R.layout.activity_view_tutorial)

        val videoView = findViewById<VideoView>(R.id.videoView);
        val buttonSkip = findViewById<Button>(R.id.button);

        // 1. Get Reference to the TextView
        val paint = buttonSkip.paint

        // 2. Measure Text Width
        val width = paint.measureText(buttonSkip.text.toString())
        // 3. Create LinearGradient Shader
        val textShader: Shader = LinearGradient(
            0f, 0f, width, buttonSkip.textSize,
            intArrayOf(
                Color.parseColor("#3BE2B0"),
                Color.parseColor("#4095D0"),
                Color.parseColor("#5986CC")
            ),
            floatArrayOf(0f, 0.5f, 1f),
            Shader.TileMode.CLAMP
        )
        // 4. Apply Shader to TextView
        paint.shader = textShader

        buttonSkip.setOnClickListener {
            val intent = Intent(this, ExerciseActivity::class.java)
            videoView.pause();
            startActivity(intent)
            finish()
        }
        if (locale == "vi") {
            videoView.setVideoURI(Uri.parse("android.resource://" + packageName + "/" + R.raw.vi_tutorial))
        } else {
            videoView.setVideoURI(Uri.parse("android.resource://" + packageName + "/" + R.raw.en_tutorial))
        }
//        val mediaController = MediaController(this);
//        videoView.setMediaController(mediaController)
//        mediaController.setAnchorView(videoView)

        // Hide the button initially
        buttonSkip.visibility = View.GONE

        // Set a listener to adjust video scaling
        videoView.setOnPreparedListener { mediaPlayer ->
            val videoWidth = mediaPlayer.videoWidth
            val videoHeight = mediaPlayer.videoHeight
            val videoProportion = videoWidth.toFloat() / videoHeight.toFloat()

            val screenWidth = videoView.width
            val screenHeight = videoView.height
            val screenProportion = screenWidth.toFloat() / screenHeight.toFloat()

            val layoutParams = videoView.layoutParams
            if (videoProportion > screenProportion) {
                layoutParams.width = screenWidth
                layoutParams.height = (screenWidth / videoProportion).toInt()
            } else {
                layoutParams.width = (screenProportion * screenHeight).toInt()
                layoutParams.height = screenHeight
            }
            videoView.layoutParams = layoutParams

            // Start the video
            videoView.start()
        }

        videoView.setOnTouchListener { _, _ ->
            buttonSkip.animate()
                .alpha(1.0f)
                .setDuration(300)
                .withStartAction { buttonSkip.visibility = View.VISIBLE }
                .start()

            // Hide the button after 3 seconds of inactivity
            Handler(Looper.getMainLooper()).postDelayed({
                buttonSkip.animate()
                    .alpha(0.0f)
                    .setDuration(300)
                    .withEndAction { buttonSkip.visibility = View.GONE }
                    .start()
            }, 3000)

            false
        }

//        videoView.start()

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