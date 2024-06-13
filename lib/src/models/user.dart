import 'profile.dart';
import 'following.dart';

class User {
  int id;
  String email;
  String username;
  String phone;
  bool isActive;
  bool isStaff;
  bool isPremium;
  int activeStatus;
  String authProvider;
  Profile profile;
  List<Following> following;
  DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.isActive,
    required this.isStaff,
    required this.isPremium,
    required this.activeStatus,
    required this.authProvider,
    required this.profile,
    required this.following,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isPremium: json['is_premium'],
      activeStatus: json['active_status'],
      authProvider: json['auth_provider'],
      profile: Profile.fromJson(json['profile']),
      following: List<Following>.from(
          json['following'].map((x) => Following.fromJson(x))),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
