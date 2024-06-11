

class Following {
  int id;
  int follower;
  int followed;

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
