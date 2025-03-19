package com.yogitech.yogi_application.network

import com.yogitech.yogi_application.model.ExerciseFeedback
import com.yogitech.yogi_application.model.FeedbackResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface FeedbackApiService {
    @POST("/api/v1/exercise-feedback/")
    suspend fun postExerciseFeedback(@Body feedback: ExerciseFeedback): Response<FeedbackResponse> // Response type depends on your API's response structure
}