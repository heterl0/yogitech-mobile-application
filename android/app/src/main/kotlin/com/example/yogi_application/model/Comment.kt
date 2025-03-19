package com.yogitech.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

@Serializable
data class Comment(
    val id: Int,
    val votes: List<Vote>,
    val text: String,
    @SerialName("created_at") val createdAt: String,
    @SerialName("updated_at") val updatedAt: String,
    @SerialName("active_status") val activeStatus: Int,
    @SerialName("parent_comment") val parentComment: Int?,
    val user: Account,
    val exercise: Int
) {
    companion object {
        fun fromJson(source: String): Comment {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}