package com.yogitech.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.json.Json
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString


@Serializable
data class Pose(
    val id: Int,
    val muscles: List<Muscle>,
    val name: String,
    @SerialName("image_url" ) val imageUrl: String,
    val duration: Int,
    val calories: String,
    @SerialName("keypoint_url") val keypointUrl: String,
    val instruction: String,
            @SerialName("created_at") val createdAt: String,
                @SerialName("updated_at") val updatedAt: String,
                    @SerialName("active_status") val activeStatus: Int,
    val level: Int
) {
    companion object {
        fun fromJson(source: String): Pose {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}
