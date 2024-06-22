import 'dart:convert';

import 'package:collection/collection.dart';



class Profile {
  final int id;
  final String user;
  final String? first_name;
  final String? last_name;
  final int point;
  final int exp;
  final int streak;
  final String? avatar_url;
  final int gender;
  final String? birthdate;
  final String? height;
  final String? weight;
  final String? bmi;
  final String created_at;
  final String updated_at;
  final int active_status;
  final int? level;

  Profile(
      this.id,
      this.user,
      this.first_name,
      this.last_name,
      this.point,
      this.exp,
      this.streak,
      this.avatar_url,
      this.gender,
      this.birthdate,
      this.height,
      this.weight,
      this.bmi,
      this.created_at,
      this.updated_at,
      this.active_status,
      this.level);

  Profile copyWith({
    int? id,
    String? user,
    String? first_name,
    String? last_name,
    int? point,
    int? exp,
    int? streak,
    String? avatar_url,
    int? gender,
    String? birthdate,
    String? height,
    String? weight,
    String? bmi,
    String? created_at,
    String? updated_at,
    int? active_status,
    int? level,
  }) {
    return Profile(
      id ?? this.id,
      user ?? this.user,
      first_name ?? this.first_name,
      last_name ?? this.last_name,
      point ?? this.point,
      exp ?? this.exp,
      streak ?? this.streak,
      avatar_url ?? this.avatar_url,
      gender ?? this.gender,
      birthdate ?? this.birthdate,
      height ?? this.height,
      weight ?? this.weight,
      bmi ?? this.bmi,
      created_at ?? this.created_at,
      updated_at ?? this.updated_at,
      active_status ?? this.active_status,
      level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'first_name': first_name,
      'last_name': last_name,
      'point': point,
      'exp': exp,
      'streak': streak,
      'avatar_url': avatar_url,
      'gender': gender,
      'birthdate': birthdate,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
      'level': level,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      map['id'] as int,
      map['user'] as String,
      map['first_name'] != null ? map['first_name'] as String : null,
      map['last_name'] != null ? map['last_name'] as String : null,
      map['point'] as int,
      map['exp'] as int,
      map['streak'] as int,
      map['avatar_url'] != null ? map['avatar_url'] as String : null,
      map['gender'] as int,
      map['birthdate'] != null ? map['birthdate'] as String : null,
      map['height'] != null ? map['height'] as String : null,
      map['weight'] != null ? map['weight'] as String : null,
      map['bmi'] != null ? map['bmi'] as String : null,
      map['created_at'] as String,
      map['updated_at'] as String,
      map['active_status'] as int,
      map['level'] != null ? map['level'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(id: $id, user: $user, first_name: $first_name, last_name: $last_name, point: $point, exp: $exp, streak: $streak, avatar_url: $avatar_url, gender: $gender, birthdate: $birthdate, height: $height, weight: $weight, bmi: $bmi, created_at: $created_at, updated_at: $updated_at, active_status: $active_status, level: $level)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.point == point &&
        other.exp == exp &&
        other.streak == streak &&
        other.avatar_url == avatar_url &&
        other.gender == gender &&
        other.birthdate == birthdate &&
        other.height == height &&
        other.weight == weight &&
        other.bmi == bmi &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        point.hashCode ^
        exp.hashCode ^
        streak.hashCode ^
        avatar_url.hashCode ^
        gender.hashCode ^
        birthdate.hashCode ^
        height.hashCode ^
        weight.hashCode ^
        bmi.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode ^
        level.hashCode;
  }
}

class Following {
  final int id;
  final int follower;
  final int followed;

  Following({
    required this.id,
    required this.follower,
    required this.followed,
  });

  Following copyWith({
    int? id,
    int? follower,
    int? followed,
  }) {
    return Following(
      id: id ?? this.id,
      follower: follower ?? this.follower,
      followed: followed ?? this.followed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'follower': follower,
      'followed': followed,
    };
  }

  factory Following.fromMap(Map<String, dynamic> map) {
    return Following(
      id: map['id'] as int,
      follower: map['follower'] as int,
      followed: map['followed'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Following.fromJson(String source) =>
      Following.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Following(id: $id, follower: $follower, followed: $followed)';

  @override
  bool operator ==(covariant Following other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.follower == follower &&
        other.followed == followed;
  }

  @override
  int get hashCode => id.hashCode ^ follower.hashCode ^ followed.hashCode;
}

class Account {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final bool? is_active;
  final bool? is_staff;
  final bool? is_premium;
  final int active_status;
  final String auth_provider;
  final Profile profile;
  final List<Following> following;
  final String? last_login;
  final String created_at;

  Account(
      this.id,
      this.username,
      this.email,
      this.phone,
      this.is_active,
      this.is_staff,
      this.is_premium,
      this.active_status,
      this.auth_provider,
      this.profile,
      this.following,
      this.last_login,
      this.created_at);

  Account copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    bool? is_active,
    bool? is_staff,
    bool? is_premium,
    int? active_status,
    String? auth_provider,
    Profile? profile,
    List<Following>? following,
    String? last_login,
    String? created_at,
  }) {
    return Account(
      id ?? this.id,
      username ?? this.username,
      email ?? this.email,
      phone ?? this.phone,
      is_active ?? this.is_active,
      is_staff ?? this.is_staff,
      is_premium ?? this.is_premium,
      active_status ?? this.active_status,
      auth_provider ?? this.auth_provider,
      profile ?? this.profile,
      following ?? this.following,
      last_login ?? this.last_login,
      created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'is_active': is_active,
      'is_staff': is_staff,
      'is_premium': is_premium,
      'active_status': active_status,
      'auth_provider': auth_provider,
      'profile': profile.toMap(),
      'following': following.map((x) => x.toMap()).toList(),
      'last_login': last_login,
      'created_at': created_at,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      map['id'] as int,
      map['username'] as String,
      map['email'] as String,
      map['phone'] as String?,
      map['is_active'] as bool?,
      map['is_staff'] as bool?,
      map['is_premium'] as bool?,
      map['active_status'] as int,
      map['auth_provider'] as String,
      Profile.fromMap(map['profile'] as Map<String, dynamic>),
      List<Following>.from(
        (map['following'] as List<dynamic>).map<Following>(
          (x) => Following.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['last_login'] != null ? map['last_login'] as String : null,
      map['created_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(id: $id, username: $username, email: $email, phone: $phone, is_active: $is_active, is_staff: $is_staff, is_premium: $is_premium, active_status: $active_status, auth_provider: $auth_provider, profile: $profile, following: $following, last_login: $last_login, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.is_active == is_active &&
        other.is_staff == is_staff &&
        other.is_premium == is_premium &&
        other.active_status == active_status &&
        other.auth_provider == auth_provider &&
        other.profile == profile &&
        listEquals(other.following, following) &&
        other.last_login == last_login &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        is_active.hashCode ^
        is_staff.hashCode ^
        is_premium.hashCode ^
        active_status.hashCode ^
        auth_provider.hashCode ^
        profile.hashCode ^
        following.hashCode ^
        last_login.hashCode ^
        created_at.hashCode;
  }
  
}
