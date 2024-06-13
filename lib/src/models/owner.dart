import 'package:yogi_application/src/models/profile.dart';

class Owner {
  int? id;
  String? email;
  String? username;
  String? phone;
  bool? isActive;
  bool? isStaff;
  bool? isPremium;
  int? activeStatus;
  String? authProvider;
  Profile? profile;
  List<dynamic>? following;
  String? createdAt;

  Owner(
      {this.id,
      this.email,
      this.username,
      this.phone,
      this.isActive,
      this.isStaff,
      this.isPremium,
      this.activeStatus,
      this.authProvider,
      this.profile,
      this.following,
      this.createdAt});

  Owner.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["username"] is String) {
      username = json["username"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["is_active"] is bool) {
      isActive = json["is_active"];
    }
    if (json["is_staff"] is bool) {
      isStaff = json["is_staff"];
    }
    if (json["is_premium"] is bool) {
      isPremium = json["is_premium"];
    }
    if (json["active_status"] is int) {
      activeStatus = json["active_status"];
    }
    if (json["auth_provider"] is String) {
      authProvider = json["auth_provider"];
    }
    if (json["profile"] is Map) {
      profile =
          json["profile"] == null ? null : Profile.fromJson(json["profile"]);
    }
    if (json["following"] is List) {
      following = json["following"] ?? [];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["email"] = email;
    _data["username"] = username;
    _data["phone"] = phone;
    _data["is_active"] = isActive;
    _data["is_staff"] = isStaff;
    _data["is_premium"] = isPremium;
    _data["active_status"] = activeStatus;
    _data["auth_provider"] = authProvider;
    if (profile != null) {
      _data["profile"] = profile?.toJson();
    }
    if (following != null) {
      _data["following"] = following;
    }
    _data["created_at"] = createdAt;
    return _data;
  }
}
