class Profile {
  int? id;
  String? user;
  String? lastName;
  String? firstName;
  int? point;
  int? exp;
  int? streak;
  String? avatarUrl;
  int? gender;
  String? birthdate;
  String? height;
  String? weight;
  String? bmi;
  int? level;
  String? createdAt;
  String? updatedAt;
  int? activeStatus;

  Profile(
      {this.id,
      this.user,
      this.lastName,
      this.firstName,
      this.point,
      this.exp,
      this.streak,
      this.avatarUrl,
      this.gender,
      this.birthdate,
      this.height,
      this.weight,
      this.bmi,
      this.level,
      this.createdAt,
      this.updatedAt,
      this.activeStatus});

  Profile.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["user"] is String) {
      user = json["user"];
    }
    if (json["last_name"] is String) {
      lastName = json["last_name"];
    }
    if (json["first_name"] is String) {
      firstName = json["first_name"];
    }
    if (json["point"] is int) {
      point = json["point"];
    }
    if (json["exp"] is int) {
      exp = json["exp"];
    }
    if (json["streak"] is int) {
      streak = json["streak"];
    }
    if (json["avatar_url"] is String) {
      avatarUrl = json["avatar_url"];
    }
    if (json["gender"] is int) {
      gender = json["gender"];
    }
    if (json["birthdate"] is String) {
      birthdate = json["birthdate"];
    }
    if (json["height"] is String) {
      height = json["height"];
    }
    if (json["weight"] is String) {
      weight = json["weight"];
    }
    if (json["bmi"] is String) {
      bmi = json["bmi"];
    }
    if (json["level"] is int) {
      level = json["level"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    if (json["active_status"] is int) {
      activeStatus = json["active_status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["user"] = user;
    _data["last_name"] = lastName;
    _data["first_name"] = firstName;
    _data["point"] = point;
    _data["exp"] = exp;
    _data["streak"] = streak;
    _data["avatar_url"] = avatarUrl;
    _data["gender"] = gender;
    _data["birthdate"] = birthdate;
    _data["height"] = height;
    _data["weight"] = weight;
    _data["bmi"] = bmi;
    _data["level"] = level;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["active_status"] = activeStatus;
    return _data;
  }
}
