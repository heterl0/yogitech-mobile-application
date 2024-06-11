class UserProfile {
  final int id;
  final String user;
  final String lastName;
  final String firstName;
  final int point;
  final int exp;
  final int streak;
  final String avatarUrl;
  final int gender;
  final DateTime birthdate;
  final double height;
  final double weight;
  final double bmi;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int activeStatus;

  UserProfile({
    required this.id,
    required this.user,
    required this.lastName,
    required this.firstName,
    required this.point,
    required this.exp,
    required this.streak,
    required this.avatarUrl,
    required this.gender,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      user: json['user'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      point: json['point'],
      exp: json['exp'],
      streak: json['streak'],
      avatarUrl: json['avatar_url'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      height: double.parse(json['height']),
      weight: double.parse(json['weight']),
      bmi: double.parse(json['bmi']),
      level: json['level'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activeStatus: json['active_status'],
    );
  }
}
