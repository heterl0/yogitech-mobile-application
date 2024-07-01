// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:YogiTech/src/models/social.dart';

class Notification {
  int id;
  int user;
  SocialProfile profile;
  String title;
  String body;
  String time;
  bool is_admin;
  String created_at;
  String updated_at;
  int active_status;

  Notification({
    required this.id,
    required this.user,
    required this.profile,
    required this.title,
    required this.body,
    required this.time,
    required this.is_admin,
    required this.created_at,
    required this.updated_at,
    required this.active_status,
  });

  Notification copyWith({
    int? id,
    int? user,
    SocialProfile? profile,
    String? title,
    String? body,
    String? time,
    bool? is_admin,
    String? created_at,
    String? updated_at,
    int? active_status,
  }) {
    return Notification(
      id: id ?? this.id,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      is_admin: is_admin ?? this.is_admin,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      active_status: active_status ?? this.active_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'profile': profile.toMap(),
      'title': title,
      'body': body,
      'time': time,
      'is_admin': is_admin,
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as int,
      user: map['user'] as int,
      profile: SocialProfile.fromMap(map['profile'] as Map<String, dynamic>),
      title: map['title'] as String,
      body: map['body'] as String,
      time: map['time'] as String,
      is_admin: map['is_admin'] as bool,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      active_status: map['active_status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notification(id: $id, user: $user, profile: $profile,  title: $title, body: $body, time: $time, is_admin: $is_admin, created_at: $created_at, updated_at: $updated_at, active_status: $active_status)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.profile == profile &&
        other.title == title &&
        other.body == body &&
        other.time == time &&
        other.is_admin == is_admin &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        profile.hashCode ^
        title.hashCode ^
        body.hashCode ^
        time.hashCode ^
        is_admin.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode;
  }
}
