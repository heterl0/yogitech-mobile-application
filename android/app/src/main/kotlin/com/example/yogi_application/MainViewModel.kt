package com.yogitech.yogi_application

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yogitech.yogi_application.model.Exercise
import com.yogitech.yogi_application.model.ExerciseFeedback
import com.yogitech.yogi_application.model.FeedbackResponse
import com.yogitech.yogi_application.model.PoseLogResult
import com.yogitech.yogi_application.network.FeedbackApiService
import com.yogitech.yogi_application.network.ServiceBuilder
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.launch

/**
 *  This ViewModel is used to store pose landmarker helper settings
 */
class MainViewModel : ViewModel() {

    private var _model = PoseLandmarkerHelper.MODEL_POSE_LANDMARKER_FULL
    private var _delegate: Int = PoseLandmarkerHelper.DELEGATE_CPU
    private var _minPoseDetectionConfidence: Float =
        PoseLandmarkerHelper.DEFAULT_POSE_DETECTION_CONFIDENCE
    private var _minPoseTrackingConfidence: Float = PoseLandmarkerHelper
        .DEFAULT_POSE_TRACKING_CONFIDENCE
    private var _minPosePresenceConfidence: Float = PoseLandmarkerHelper
        .DEFAULT_POSE_PRESENCE_CONFIDENCE
    var flutterEngine: FlutterEngine? = null
    val currentDelegate: Int get() = _delegate
    val currentModel: Int get() = _model
    val currentMinPoseDetectionConfidence: Float
        get() =
            _minPoseDetectionConfidence
    val currentMinPoseTrackingConfidence: Float
        get() =
            _minPoseTrackingConfidence
    val currentMinPosePresenceConfidence: Float
        get() =
            _minPosePresenceConfidence

    var restTime: Long = 10000;
    var currentIndex: Int = 0;

    var exercise: Exercise? = null;

    var local: String? = "en";

    var poseLogResults: MutableList<PoseLogResult> = mutableListOf<PoseLogResult>();

    private val _eventTrigger = MutableLiveData<Int>()
    val eventTrigger: LiveData<Int> = _eventTrigger
    var pauseCamera: MutableLiveData<Boolean> = MutableLiveData()
    fun triggerEvent() {
        _eventTrigger.value = currentIndex + 1;
        currentIndex += 1;
    }

//    fun setExercise(exercise: Exercise?) {
//        if (exercise != null) {
//            this.exercise = exercise;
//        }
//    }

    fun setDelegate(delegate: Int) {
        _delegate = delegate
    }

    fun setMinPoseDetectionConfidence(confidence: Float) {
        _minPoseDetectionConfidence = confidence
    }

    fun setMinPoseTrackingConfidence(confidence: Float) {
        _minPoseTrackingConfidence = confidence
    }

    fun setMinPosePresenceConfidence(confidence: Float) {
        _minPosePresenceConfidence = confidence
    }

    fun setModel(model: Int) {
        _model = model
    }

    private val apiService: FeedbackApiService by lazy {
        ServiceBuilder.buildService(FeedbackApiService::class.java)
    }

    private val _feedbackResult = MutableLiveData<FeedbackResult>()
    val feedbackResult: LiveData<FeedbackResult> get() = _feedbackResult

    fun postExerciseFeedback(feedback: ExerciseFeedback) {
        viewModelScope.launch { // Use viewModelScope for coroutine
            try {
                val response = apiService.postExerciseFeedback(feedback)
                if (response.isSuccessful) {
                    // Handle successful response (update UI using LiveData)
                    val data = response.body()
                    _feedbackResult.value = FeedbackResult.Success(response.body())
                    Log.d("noTag", "postExerciseFeedback: ${response.body()?.feedback?.getFeedback()}")

                } else {
                    // Handle error response
                    val errorBody = response.errorBody()?.string() ?: "Unknown error"
                    _feedbackResult.value = FeedbackResult.Error(errorBody)
                    Log.d("noTag", "postExerciseFeedback: $errorBody")
                }
            } catch (e: Exception) {
                // Handle network errors
                _feedbackResult.value = FeedbackResult.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun getScore(): Float {
        if (poseLogResults.isEmpty()) {
            return 0.toFloat();
        }
        var totalScore = 0f
        for (result in poseLogResults) {
            totalScore += result.score
        }
        val mean = totalScore / poseLogResults.size
        return String.format("%.0f", mean).toFloat()
    }


}

sealed class FeedbackResult {
    data class Success(val data: FeedbackResponse?) : FeedbackResult() // Adjust for your actual response type
    data class Error(val message: String) : FeedbackResult()
}