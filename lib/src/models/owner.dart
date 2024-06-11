import 'user_profile.dart';
import 'following.dart';

class Owner {
  final int id;
  final String email;
  final String username;
  final String phone;
  final bool isActive;
  final bool isStaff;
  final bool isPremium;
  final int activeStatus;
  final String authProvider;
  final UserProfile profile;
  final List<Following> following;
  final DateTime createdAt;

  Owner({
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

  factory Owner.fromJson(Map<String, dynamic> json) {
    var followingList = json['following'] as List;
    List<Following> following = followingList
        .map((i) => Following.fromJson(i as Map<String, dynamic>))
        .toList();

    return Owner(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      phone: json['phone'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      isPremium: json['is_premium'],
      activeStatus: json['active_status'],
      authProvider: json['auth_provider'],
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      following: following,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
