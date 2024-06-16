// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Owner {
  int? id;
  String? email;
  String? username;
  String? phone;
  bool? is_active;
  bool? is_staff;
  bool? is_premium;
  int? active_status;
  String? auth_provider;
  Profile? profile;
  List<dynamic>? following;
  String? created_at;

  Owner({
    this.id,
    this.email,
    this.username,
    this.phone,
    this.is_active,
    this.is_staff,
    this.is_premium,
    this.active_status,
    this.auth_provider,
    this.profile,
    this.following,
    this.created_at,
  });

  Owner copyWith({
    int? id,
    String? email,
    String? username,
    String? phone,
    bool? is_active,
    bool? is_staff,
    bool? is_premium,
    int? active_status,
    String? auth_provider,
    Profile? profile,
    List<dynamic>? following,
    String? created_at,
  }) {
    return Owner(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      is_active: is_active ?? this.is_active,
      is_staff: is_staff ?? this.is_staff,
      is_premium: is_premium ?? this.is_premium,
      active_status: active_status ?? this.active_status,
      auth_provider: auth_provider ?? this.auth_provider,
      profile: profile ?? this.profile,
      following: following ?? this.following,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'is_active': is_active,
      'is_staff': is_staff,
      'is_premium': is_premium,
      'active_status': active_status,
      'auth_provider': auth_provider,
      'profile': profile?.toMap(),
      'following': following,
      'created_at': created_at,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'] != null ? map['id'] as int : null,
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      is_active: map['is_active'] != null ? map['is_active'] as bool : null,
      is_staff: map['is_staff'] != null ? map['is_staff'] as bool : null,
      is_premium: map['is_premium'] != null ? map['is_premium'] as bool : null,
      active_status: map['active_status'] != null ? map['active_status'] as int : null,
      auth_provider: map['auth_provider'] != null ? map['auth_provider'] as String : null,
      profile: map['profile'] != null ? Profile.fromMap(map['profile'] as Map<String,dynamic>) : null,
      following: map['following'] != null ? List<dynamic>.from((map['following'] as List<dynamic>) : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Owner(id: $id, email: $email, username: $username, phone: $phone, is_active: $is_active, is_staff: $is_staff, is_premium: $is_premium, active_status: $active_status, auth_provider: $auth_provider, profile: $profile, following: $following, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant Owner other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.username == username &&
      other.phone == phone &&
      other.is_active == is_active &&
      other.is_staff == is_staff &&
      other.is_premium == is_premium &&
      other.active_status == active_status &&
      other.auth_provider == auth_provider &&
      other.profile == profile &&
      listEquals(other.following, following) &&
      other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        phone.hashCode ^
        is_active.hashCode ^
        is_staff.hashCode ^
        is_premium.hashCode ^
        active_status.hashCode ^
        auth_provider.hashCode ^
        profile.hashCode ^
        following.hashCode ^
        created_at.hashCode;
  }
}

class Profile {
  // Define the Profile class based on your structure
  Profile();

  Map<String, dynamic> toMap() {
    return {};
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile();
  }
}
