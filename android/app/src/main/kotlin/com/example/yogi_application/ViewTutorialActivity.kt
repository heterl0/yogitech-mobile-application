package com.yogitech.yogi_application

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

        // Lấy ngôn ngữ từ SharedPreferences
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val locale = prefs.getString("flutter.locale", "en") ?: "en"
        setLocale(this, locale)

        setContentView(R.layout.activity_view_tutorial)

        val videoView = findViewById<VideoView>(R.id.videoView)
        val buttonSkip = findViewById<Button>(R.id.button)

        // Tạo hiệu ứng gradient cho nút "Bỏ qua"
        val paint = buttonSkip.paint
        val width = paint.measureText(buttonSkip.text.toString())
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
        paint.shader = textShader

        // Xử lý khi nhấn nút "Bỏ qua"
        buttonSkip.setOnClickListener {
            val intent = Intent(this, ExerciseActivity::class.java)
            videoView.pause()
            startActivity(intent)
            finish()
        }

        // **Cập nhật để sử dụng video từ Cloudflare**
        val videoUrl = "https://storage.zenaiyoga.com/res/raw/${locale}_tutorial.mp4"
        videoView.setVideoURI(Uri.parse(videoUrl))

        // Ẩn nút ban đầu
        buttonSkip.visibility = View.GONE

        // Xử lý sự kiện khi video chuẩn bị phát
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

            videoView.start()
        }

        // Nếu có lỗi khi tải video, báo lỗi
        videoView.setOnErrorListener { _, _, _ ->
            buttonSkip.visibility = View.VISIBLE
            true
        }

        // display skip button
        videoView.setOnTouchListener { _, _ ->
            buttonSkip.animate()
                .alpha(1.0f)
                .setDuration(300)
                .withStartAction { buttonSkip.visibility = View.VISIBLE }
                .start()

            // Ẩn nút sau 3 giây
            Handler(Looper.getMainLooper()).postDelayed({
                buttonSkip.animate()
                    .alpha(0.0f)
                    .setDuration(300)
                    .withEndAction { buttonSkip.visibility = View.GONE }
                    .start()
            }, 3000)

            false
        }
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
