package com.example.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Profile(
    val id: Int,
    val user: String,
    @SerialName("first_name") val firstName: String?,
    @SerialName("last_name") val lastName: String?,
    val point: Int,
    val exp: Int,
    val streak: Int,
    @SerialName("avatar_url") val avatarUrl: String?,
    val gender: Int,
    val birthdate: String?,
    val height: String?,
    val weight: String?,
    val bmi: String?,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
    @SerialName("active_status") val activeStatus: Int,
    val level: Int?
) {
    companion object {
        fun fromJson(source: String): Profile {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}