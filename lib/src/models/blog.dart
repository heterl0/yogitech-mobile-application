import 'owner.dart';
import 'vote.dart';

class Blog {
  final int id;
  final Owner owner;
  final String title;
  final String description;
  final String imageUrl;
  final String content;
  final String benefit;
  final List<Vote> votes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int activeStatus;

  Blog({
    required this.id,
    required this.owner,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
    required this.benefit,
    required this.votes,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    var voteList = json['votes'] as List;
    List<Vote> votes =
        voteList.map((i) => Vote.fromJson(i as Map<String, dynamic>)).toList();

    return Blog(
      id: json['id'],
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      content: json['content'],
      benefit: json['benefit'],
      votes: votes,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activeStatus: json['active_status'],
    );
  }
}
