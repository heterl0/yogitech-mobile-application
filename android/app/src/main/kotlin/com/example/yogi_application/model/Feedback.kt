package com.example.yogi_application.model

import com.google.gson.annotations.SerializedName
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class KeyPoint(
    val x: Float,
    val y: Float,
    val z: Float,
    val visibility: Float
) {
    companion object {
        fun fromJson(source: String): KeyPoint {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}

@Serializable
data class ExerciseFeedback(
    val correct_keypoint: List<KeyPoint>? = null,
    val user_keypoint: List<KeyPoint>? = null
) {

    companion object {
        fun fromJson(source: String): ExerciseFeedback {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}

@Serializable
data class FeedbackResponse(
    val feedback: FeedbackDetails?,
    val score: Float,
    @SerialName("is_valid") val isValid: Boolean
) {
    companion object {
        fun fromJson(source: String): FeedbackResponse {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}

@Serializable
data class FeedbackDetails(
    @SerializedName("Left Elbow") val leftElbow: String? = null,
    @SerializedName("Right Elbow") val rightElbow: String? = null,
    @SerializedName("Left Shoulder") val leftShoulder: String? = null,
    @SerializedName("Right Shoulder") val rightShoulder: String? = null,
    @SerializedName("Left Hip") val leftHip: String? = null,
    @SerializedName("Right Hip") val rightHip: String? = null,
    @SerializedName("Left Knee") val leftKnee: String? = null,
    @SerializedName("Right Knee") val rightKnee: String? = null
) {
    companion object {
        fun fromJson(source: String): FeedbackDetails {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}
