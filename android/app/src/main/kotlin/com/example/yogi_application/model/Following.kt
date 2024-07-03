package com.example.yogi_application.model

import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Following(
    val id: Int,
    val follower: Int,
    val followed: Int
) {
    companion object {
        fun fromJson(source: String): Following {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}