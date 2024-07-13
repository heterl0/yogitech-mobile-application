package com.example.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Vote(
    val id: Int,
    @SerialName("user_id") val userId: Int,
    val user: String,
    val comment: Int,
    @SerialName("vote_value") val voteValue: Int,
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