package com.example.yogi_application.fragment

import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import com.example.yogi_application.FeedbackResult
import com.example.yogi_application.MainViewModel
import com.example.yogi_application.R
import com.example.yogi_application.databinding.FragmentScoreBinding

class ScoreFragment: Fragment(R.layout.fragment_score) {
    private var _fragmentScoreBinding: FragmentScoreBinding? = null

    private val fragmentCameraBinding
        get() = _fragmentScoreBinding!!

    private val viewModel: MainViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _fragmentScoreBinding = FragmentScoreBinding.inflate(inflater, container, false);
        return _fragmentScoreBinding!!.root;
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val gradientTextView = _fragmentScoreBinding!!.result;
        // 1. Get Reference to the TextView
        val paint = gradientTextView.paint

        // 2. Measure Text Width
        val width = paint.measureText(gradientTextView.text.toString())
        // 3. Create LinearGradient Shader
        val textShader: Shader = LinearGradient(
            0f, 0f, width, gradientTextView.textSize,
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

        viewModel.feedbackResult.observe(viewLifecycleOwner) {
            result -> when(result) {
            is FeedbackResult.Error -> {
                _fragmentScoreBinding!!.description.text = result.message;

            }
            is FeedbackResult.Success -> {
                if (result.data?.isValid == false) {
                    _fragmentScoreBinding!!.result.text = "0%";
                    _fragmentScoreBinding!!.description.text = "Adjust your body full in screen"
                } else {
                    _fragmentScoreBinding!!.result.text = "${result.data?.score.toString()}%";
                }
            }
            }
        }

    }
}

