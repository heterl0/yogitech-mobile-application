package com.yogitech.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json


@Serializable
data class Muscle(
    val id: Int,
    val name: String,
    val image: String,
    val description: String,
    @SerialName("created_at") val createdAt: String,
        @SerialName("updated_at") val updatedAt: String,
        @SerialName("active_status") val activeStatus: Int
) {
    companion object {
        fun fromJson(source: String): Muscle {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}
