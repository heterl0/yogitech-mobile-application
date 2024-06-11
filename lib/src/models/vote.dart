class Vote {
  final int id;
  final String user;
  final String userId;
  final String blog;
  final int voteValue;

  Vote({
    required this.id,
    required this.user,
    required this.userId,
    required this.blog,
    required this.voteValue,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      user: json['user'],
      userId: json['user_id'],
      blog: json['blog'],
      voteValue: json['vote_value'],
    );
  }
}
