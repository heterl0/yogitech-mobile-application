// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SocialProfile {
  int? user_id;
  String? username;
  String? first_name;
  String? last_name;
  int? streak;
  String? avatar;
  int? exp;
  int? level;

  SocialProfile({
    this.user_id,
    this.username,
    this.first_name,
    this.last_name,
    this.streak,
    this.avatar,
    this.exp,
    this.level,
  });

  SocialProfile copyWith({
    int? user_id,
    String? username,
    String? first_name,
    String? last_name,
    int? streak,
    String? avatar,
    int? exp,
    int? level,
  }) {
    return SocialProfile(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      streak: streak ?? this.streak,
      avatar: avatar ?? this.avatar,
      exp: exp ?? this.exp,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': user_id,
      'username': username,
      'first_name': first_name,
      'last_name': last_name,
      'streak': streak,
      'avatar': avatar,
      'exp': exp,
      'level': level,
    };
  }

  factory SocialProfile.fromMap(Map<String, dynamic> map) {
    return SocialProfile(
      user_id: map['user_id'] != null ? map['user_id'] as int : null,
      username: map['username'] != null ? map['username'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      streak: map['streak'] != null ? map['streak'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      exp: map['exp'] != null ? map['exp'] as int : null,
      level: map['level'] != null ? map['level'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialProfile.fromJson(String source) =>
      SocialProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SocialProfile(user_id: $user_id, username: $username, first_name: $first_name, last_name: $last_name, streak: $streak, avatar: $avatar, exp: $exp, level: $level)';
  }

  @override
  bool operator ==(covariant SocialProfile other) {
    if (identical(this, other)) return true;

    return other.user_id == user_id &&
        other.username == username &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.streak == streak &&
        other.avatar == avatar &&
        other.exp == exp &&
        other.level == level;
  }

  @override
  int get hashCode {
    return user_id.hashCode ^
        username.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        streak.hashCode ^
        avatar.hashCode ^
        exp.hashCode ^
        level.hashCode;
  }
}
