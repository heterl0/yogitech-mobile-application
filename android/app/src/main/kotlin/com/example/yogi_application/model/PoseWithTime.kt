package com.yogitech.yogi_application.model

import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json


@Serializable
data class PoseWithTime(
    val pose: Pose,
    val time: Int,
    val duration: Int
) {
    companion object {
        fun fromJson(source: String): PoseWithTime {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}