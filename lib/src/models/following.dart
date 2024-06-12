class Following {
  final int id;
  final int follower;
  final int followed;

  Following({
    required this.id,
    required this.follower,
    required this.followed,
  });

  factory Following.fromJson(Map<String, dynamic> json) {
    return Following(
      id: json['id'],
      follower: json['follower'],
      followed: json['followed'],
    );
  }
}
