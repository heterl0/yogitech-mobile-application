package com.yogitech.yogi_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json


@Serializable
data class Account(
    val id: Int,
    val username: String,
    val email: String,
    val phone: String?,
    @SerialName("is_active") val isActive: Boolean?,
    @SerialName("is_staff") val isStaff: Boolean?,
    @SerialName("is_premium") val isPremium: Boolean?,
    @SerialName("active_status") val activeStatus: Int,
    @SerialName("auth_provider") val authProvider: String,
    val profile: Profile,
    val following: List<Following>,
    val followers: List<Following>,
    @SerialName("last_login") val lastLogin: String?,
    @SerialName("created_at") val createdAt: String
) {
    companion object {
        fun fromJson(source: String): Account {
            return Json.decodeFromString(source)
        }
    }

    fun toJson(): String {
        return Json.encodeToString(this)
    }
}