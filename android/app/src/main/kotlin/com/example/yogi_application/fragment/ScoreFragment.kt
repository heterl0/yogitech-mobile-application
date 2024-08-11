package com.example.yogi_application.fragment

import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Shader
import android.os.Bundle
import android.os.CountDownTimer
import android.speech.tts.TextToSpeech
import android.util.Log
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import com.example.yogi_application.BuildConfig
import com.example.yogi_application.FeedbackResult
import com.example.yogi_application.MainViewModel
import com.example.yogi_application.R
import com.example.yogi_application.databinding.FragmentScoreBinding
import com.example.yogi_application.model.PoseLogResult
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.Locale

class ScoreFragment: Fragment(R.layout.fragment_score), TextToSpeech.OnInitListener {

    private lateinit var tts: TextToSpeech
    private val localeEN = Locale("en", "US")
    private val localeVI = Locale("vi", "VN")
    private var countDownThree = false;
    private var lastSpokenText: String? = null

    private var _fragmentScoreBinding: FragmentScoreBinding? = null

    private val fragmentCameraBinding
        get() = _fragmentScoreBinding!!

    private var isTimerRunning = false
    private var isWaitingRunning = false

    private val viewModel: MainViewModel by activityViewModels()

    private val scoreList: MutableList<Float> = mutableListOf<Float>();
    private var timeLeftInMillis: Long = 0
    private var isCountDown = true

    private var countDownTimer: CountDownTimer? = null
    var startTime: Long? = null
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _fragmentScoreBinding = FragmentScoreBinding.inflate(inflater, container, false);
        setHasOptionsMenu(true)  // Enable options menu in fragment
        tts = TextToSpeech(requireContext(), this)

        return _fragmentScoreBinding!!.root;
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            // Set default language to English
            val result = tts.setLanguage(localeVI)


            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Log.e("TTS", "Language not supported")
            } else {
                // Set the pitch and speech rate suitable for yoga instructions
                tts.setPitch(1.0f) // Normal pitch
                tts.setSpeechRate(0.8f) // Slightly slower speech rate
            }
        } else {
            Log.e("TTS", "Initialization failed")
        }
    }



    private fun speak(text: String, language: Locale) {
        tts.language = language
        if (!tts.isSpeaking && text != lastSpokenText) {
            tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, "")
            lastSpokenText = text
        }
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        _fragmentScoreBinding!!.pauseButton.setOnClickListener {
            viewModel.pauseCamera.value = true;
        }

        viewModel.pauseCamera.observe(viewLifecycleOwner) {
            isPause -> if (!isPause) {

                val rawMod = timeLeftInMillis % 1000 // Calculate the raw modulus
                val roundFactor = if (rawMod >= 1000 / 2) 1000 else 0 // Round up or down
                val value = ((timeLeftInMillis / 1000) * 1000 + roundFactor).toInt()
                if (roundFactor != 0) {
                    if (isCountDown) {
                        isTimerRunning = false
                        startCountDownTimer(value);
                    } else {
                        isWaitingRunning = false
                        startWaitingTimer(value.toLong());
                    }
                }
            } else {
                countDownTimer?.cancel();
            }
        }

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
        triggerObserve()

    }

    private fun triggerObserve() {
        Log.d("Trigger Again", "triggerObserve: ")
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
                            var duration = 1000;
                            startCountDownTimer(duration)
                        }
                    } else {
                        Log.d("Result", "triggerObserve: $result")
                        if (result.data?.isValid == false) {
                            _fragmentScoreBinding!!.result.text = "0%";
                            _fragmentScoreBinding!!.description.text =
                                getString(R.string.adjust)
                            if (
                                viewModel.local == "en"
                            ) {
                                speak(getString(R.string.adjust), localeEN);
                            } else {
                                speak(getString(R.string.adjust), localeVI);
                            }
                        } else {
                            _fragmentScoreBinding!!.result.text =
                                "${result.data?.score?.toInt().toString()}%";
                            val feedbacks = result.data?.feedback?.getFeedback()
                            if (feedbacks?.size == 2) {
                                var feedback1Name = feedbacks[0] // Replace with your actual string name
                                feedback1Name = feedback1Name?.toLowerCase()?.replace(" ", "")?.replace(".", "")
                                Log.d("feedback 1", "$feedback1Name");
                                val feedback1ResId = resources.getIdentifier(feedback1Name, "string", context?.packageName)
                                val feedback1 = getString(feedback1ResId)
                                var feedback2Name = feedbacks[1] // Replace with your actual string name
                                feedback2Name = feedback2Name?.toLowerCase()?.replace(" ", "")?.replace(".", "")
                                Log.d("feedback 2", "$feedback2Name");
                                val feedback2ResId = resources.getIdentifier(feedback2Name, "string", context?.packageName)
                                val feedback2 = getString(feedback2ResId)
                                val feedback = feedback1 + ", " + feedback2
                                if (!countDownThree)
                                if (viewModel.local == "en") {
                                    speak(feedback, localeEN);
                                } else {
                                    speak(feedback, localeVI)
                                }
                                _fragmentScoreBinding!!.description.text =
                                    feedback
                            } else {
                                if (!countDownThree)
                                if (viewModel.local == "en") {
                                    speak(getString(R.string.goodJob), localeEN);
                                } else {
                                    speak(getString(R.string.goodJob), localeVI)
                                }
                                _fragmentScoreBinding!!.description.text =
                                    getString(R.string.goodJob)
                            }

                            if (isTimerRunning) {
                                scoreList.add(result.data?.score!!)
                            }
                            if (result.data?.score!! > 80 && !isTimerRunning && !isWaitingRunning) {
                                var duration = viewModel.exercise?.poses?.get(viewModel.currentIndex)?.duration!! * 1000
                                startCountDownTimer(duration)
                            }
                        }
                    }
                }
            }
        }
        }

    }

    private fun startCountDownTimer(duration: Int) {
        if (isTimerRunning) return
        isCountDown = true;
        countDownTimer?.cancel()
        isTimerRunning = true
        countDownTimer = object : CountDownTimer(duration.toLong(), 1000) {

            override fun onTick(millisUntilFinished: Long) {
                timeLeftInMillis = millisUntilFinished
                val secondsRemaining = millisUntilFinished / 1000
                if (secondsRemaining.toInt() == 3) {
                    countDownThree = true;
                }
                if (countDownThree) {
                    if (viewModel.local == "en") {
                        speak(secondsRemaining.toString(), localeEN);
                    } else {
                        speak(secondsRemaining.toString(), localeVI)
                    }
                }
                _fragmentScoreBinding!!.timer.text = "00:$secondsRemaining"
            }

            override fun onFinish() {
                countDownThree = false
                _fragmentScoreBinding!!.timer.text = ""
                isTimerRunning = false
                val currentIndex = viewModel.currentIndex
                if (currentIndex < viewModel.exercise?.poses?.size!!) {
                    Log.d("currentIndex", currentIndex.toString())
                    val second = (System.currentTimeMillis() - startTime!!) / 1000.0
                    val poseLogResult: PoseLogResult = PoseLogResult(
                        viewModel.exercise?.poses?.get(currentIndex)?.pose?.id!!,
                        calculateMean(scoreList),
                        second.toInt()
                    )
                    startTime = null
                    scoreList.removeAll(scoreList);
                    viewModel.poseLogResults.add(poseLogResult)
                    if (viewModel.local == "en") {
                        speak(getString(R.string.takeARest), localeEN);
                    } else {
                        speak(getString(R.string.takeARest), localeVI)
                    }
                } else {
                    if (viewModel.local == "en") {
                        speak(getString(R.string.finishTheExercise), localeEN);
                    } else {
                        speak(getString(R.string.finishTheExercise), localeVI)
                    }
                }
                viewModel.triggerEvent();
                var duration = viewModel.restTime
                if (BuildConfig.DEV_MODE == true) duration = 1000;
                startWaitingTimer(duration);
            }
        }.start()
    }

    private fun startWaitingTimer(duration: Long) {
        if (isWaitingRunning) return
        isCountDown = false
        countDownTimer?.cancel()
        isWaitingRunning = true
//        val duration = viewModel.exercise?.poses?.get(viewModel.currentIndex)?.duration!! * 1000

        countDownTimer = object : CountDownTimer(duration, 1000) {

            override fun onTick(millisUntilFinished: Long) {
                val secondsRemaining = millisUntilFinished / 1000
                if (secondsRemaining.toInt() == 3) {
                    countDownThree = true;
                }
                if (countDownThree) {
                    if (viewModel.local == "en") {
                        speak(secondsRemaining.toString(), localeEN);
                    } else {
                        speak(secondsRemaining.toString(), localeVI)
                    }
                }
                timeLeftInMillis = millisUntilFinished

                _fragmentScoreBinding!!.timer.text = "00:$secondsRemaining"
                _fragmentScoreBinding!!.result.text = getString(R.string.takeARest);
                _fragmentScoreBinding!!.description.text = getString(R.string.breathSlowly);
            }

            override fun onFinish() {
                countDownThree = false
                _fragmentScoreBinding!!.timer.text = ""
                isWaitingRunning = false
                if (viewModel.local == "en") {
                    speak(getString(R.string.nextExercise), localeEN);
                } else {
                    speak(getString(R.string.nextExercise), localeVI)
                }
            }
        }.start()
    }




    override fun onDestroyView() {
        super.onDestroyView()
        if (tts != null) {
            tts.stop()
            tts.shutdown()
        }
        _fragmentScoreBinding = null
        countDownTimer?.cancel()
    }

    fun calculateMean(numbers: List<Float>): Float {
        if (numbers.isEmpty()) {
            return 0.toFloat()
        }

        val sum = numbers.sum()
        val mean = sum / numbers.size

        // Use BigDecimal for precise rounding and convert it back to float
        val meanBigDecimal = BigDecimal(mean.toString()).setScale(2, RoundingMode.HALF_UP)
        return meanBigDecimal.toFloat()
    }
}

