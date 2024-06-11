import 'level.dart';

class UserProfile {
  final int? id;
  final int userId;
  final String? lastName;
  final String? firstName;
  final int point;
  final int exp;
  final int streak;
  final String? avatar;
  final int gender;
  final DateTime? birthdate;
  final double? height;
  final double? weight;
  final double? bmi;
  final Level? level;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int activeStatus;

  UserProfile({
    this.id,
    required this.userId,
    this.lastName,
    this.firstName,
    required this.point,
    required this.exp,
    required this.streak,
    this.avatar,
    required this.gender,
    this.birthdate,
    this.height,
    this.weight,
    this.bmi,
    this.level,
    this.createdAt,
    this.updatedAt,
    required this.activeStatus,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userId: json['user'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      point: json['point'],
      exp: json['exp'],
      streak: json['streak'],
      avatar: json['avatar'],
      gender: json['gender'],
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      bmi: json['bmi']?.toDouble(),
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      activeStatus: json['active_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'last_name': lastName,
      'first_name': firstName,
      'point': point,
      'exp': exp,
      'streak': streak,
      'avatar': avatar,
      'gender': gender,
      'birthdate': birthdate?.toIso8601String(),
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'level': level?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'active_status': activeStatus,
    };
  }
}
