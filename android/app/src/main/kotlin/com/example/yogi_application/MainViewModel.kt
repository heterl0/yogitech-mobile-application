/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.example.yogi_application

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.yogi_application.model.ExerciseFeedback
import com.example.yogi_application.model.FeedbackResponse
import com.example.yogi_application.network.FeedbackApiService
import com.example.yogi_application.network.ServiceBuilder
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
                    Log.d("noTag", "postExerciseFeedback: $data")
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
}

sealed class FeedbackResult {
    data class Success(val data: FeedbackResponse?) : FeedbackResult() // Adjust for your actual response type
    data class Error(val message: String) : FeedbackResult()
}