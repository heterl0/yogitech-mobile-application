package com.example.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json


@Serializable
data class Exercise(
    val id: Int,
    val title: String,
    @SerialName("image_url") val imageUrl: String,
    @SerialName("video_url") val videoUrl: String,
    val durations: Int?,
    val level: Int,
    val benefit: String,
    val description: String,
    val calories: String,
    @SerialName("number_poses") val numberPoses : Int,
    val point: Int,
    @SerialName("is_premium") val isPremium : Boolean,
        @SerialName("created_at") val createdAt: String,
            @SerialName("updated_at") val updatedAt: String,
    val owner: Int?,
        @SerialName("active_status") val activeStatus: Int,
    val poses: List<PoseWithTime>,
    val comments: List<Comment>,
    @SerialName("is_admin") val isAdmin: Boolean
) {
    companion object {
        fun fromJson(source: String): Exercise {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }


}