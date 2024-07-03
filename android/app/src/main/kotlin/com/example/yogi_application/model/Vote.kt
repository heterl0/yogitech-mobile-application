package com.example.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Vote(
    val id: Int,
    val userId: Int,
    val value: Int,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
    @SerialName("active_status") val activeStatus: Int
) {
    companion object {
        fun fromJson(source: String): Vote {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}