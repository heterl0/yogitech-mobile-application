package com.example.yogi_application.fragment

import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import com.example.yogi_application.BuildConfig
import com.example.yogi_application.FeedbackResult
import com.example.yogi_application.MainViewModel
import com.example.yogi_application.R
import com.example.yogi_application.databinding.FragmentScoreBinding
import com.example.yogi_application.model.PoseLogResult

class ScoreFragment: Fragment(R.layout.fragment_score) {
    private var _fragmentScoreBinding: FragmentScoreBinding? = null

    private val fragmentCameraBinding
        get() = _fragmentScoreBinding!!

    private var isTimerRunning = false
    private var isWaitingRunning = false

    private val viewModel: MainViewModel by activityViewModels()

    private val scoreList: MutableList<Float> = mutableListOf<Float>();


    private var countDownTimer: CountDownTimer? = null
    var startTime: Long? = null
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
                if (startTime == null) {
                    startTime = System.currentTimeMillis();
                }
                if (!isWaitingRunning) {
                    if (BuildConfig.DEV_MODE == true) {
                        if (!isTimerRunning) {
                            startCountDownTimer()
                        }
                    } else {
                        if (result.data?.isValid == false) {
                            _fragmentScoreBinding!!.result.text = "0%";
                            _fragmentScoreBinding!!.description.text =
                                "Adjust your body full in screen"
                        } else {
                            _fragmentScoreBinding!!.result.text =
                                "${result.data?.score?.toInt().toString()}%";
                            _fragmentScoreBinding!!.description.text =
                                "${result.data?.feedback?.getFeedback()}"
                            if (isTimerRunning) {
                                scoreList.add(result.data?.score!!)
                            }
                            if (result.data?.score!! > 80 && !isTimerRunning && !isWaitingRunning) {
                                startCountDownTimer()
                            }
                        }
                    }
                }
            }
            }
        }

    }

    private fun startCountDownTimer() {
        if (isTimerRunning) return
        countDownTimer?.cancel()
        isTimerRunning = true
        var duration = viewModel.exercise?.poses?.get(viewModel.currentIndex)?.duration!! * 1000
        if (BuildConfig.DEV_MODE == true) duration = 1000;
        countDownTimer = object : CountDownTimer(duration.toLong(), 1000) {

            override fun onTick(millisUntilFinished: Long) {
                val secondsRemaining = millisUntilFinished / 1000
                _fragmentScoreBinding!!.timer.text = "00:$secondsRemaining"
            }

            override fun onFinish() {
                _fragmentScoreBinding!!.timer.text = ""
                isTimerRunning = false
                val currentIndex = viewModel.currentIndex
                if (currentIndex < viewModel.exercise?.poses?.size!!) {
                    Log.d("NoTag", currentIndex.toString())
                    val second = (System.currentTimeMillis() - startTime!!) / 1000.0
                    val poseLogResult: PoseLogResult = PoseLogResult(
                        viewModel.exercise?.poses?.get(currentIndex)?.pose?.id!!,
                        calculateMean(scoreList),
                        second.toInt()
                    )
                    startTime = null
                    scoreList.removeAll(scoreList);
                    viewModel.poseLogResults.add(poseLogResult)
                }
                viewModel.triggerEvent();
                startWaitingTimer();
            }
        }.start()
    }

    private fun startWaitingTimer() {
        if (isWaitingRunning) return
        countDownTimer?.cancel()
        isWaitingRunning = true
//        val duration = viewModel.exercise?.poses?.get(viewModel.currentIndex)?.duration!! * 1000
        var duration = 10000
        if (BuildConfig.DEV_MODE == true) duration = 1000;
        countDownTimer = object : CountDownTimer(duration.toLong(), 1000) {

            override fun onTick(millisUntilFinished: Long) {
                val secondsRemaining = millisUntilFinished / 1000
                _fragmentScoreBinding!!.timer.text = "00:$secondsRemaining"
                _fragmentScoreBinding!!.result.text = "Take a rest";
                _fragmentScoreBinding!!.description.text = "Breath slowly."
            }

            override fun onFinish() {
                _fragmentScoreBinding!!.timer.text = ""
                isWaitingRunning = false
            }
        }.start()
    }




    override fun onDestroyView() {
        super.onDestroyView()
        _fragmentScoreBinding = null
        countDownTimer?.cancel()
    }

    fun calculateMean(numbers: List<Float>): Float {
        if (numbers.isEmpty()) {
//            throw IllegalArgumentException("The list cannot be empty")
            return 0.toFloat()
        }
        val sum = numbers.sum()
        val mean =  sum / numbers.size
        return String.format("%.2f", mean).toFloat()
    }
}

