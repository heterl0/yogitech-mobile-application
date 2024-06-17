// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:yogi_application/src/models/account.dart';

class BlogVote {
  final int id;
  final String user;
  final String userId;
  final String blog;
  final int voteValue;

  BlogVote(this.id, this.user, this.userId, this.blog, this.voteValue);

  BlogVote copyWith({
    int? id,
    String? user,
    String? userId,
    String? blog,
    int? voteValue,
  }) {
    return BlogVote(
      id ?? this.id,
      user ?? this.user,
      userId ?? this.userId,
      blog ?? this.blog,
      voteValue ?? this.voteValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'userId': userId,
      'blog': blog,
      'voteValue': voteValue,
    };
  }

  factory BlogVote.fromMap(Map<String, dynamic> map) {
    return BlogVote(
      map['id'] as int,
      map['user'] as String,
      map['userId'] as String,
      map['blog'] as String,
      map['voteValue'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogVote.fromJson(String source) =>
      BlogVote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlogVote(id: $id, user: $user, userId: $userId, blog: $blog, voteValue: $voteValue)';
  }

  @override
  bool operator ==(covariant BlogVote other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.userId == userId &&
        other.blog == blog &&
        other.voteValue == voteValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        userId.hashCode ^
        blog.hashCode ^
        voteValue.hashCode;
  }
}

class Blog {
  final int id;
  final Account owner;
  final String title;
  final String description;
  final String image_url;
  final String content;
  final String benefit;
  final List<BlogVote> votes;
  final String created_at;
  final String updated_at;
  final int active_status;

  Blog(
      this.id,
      this.owner,
      this.title,
      this.description,
      this.image_url,
      this.content,
      this.benefit,
      this.votes,
      this.created_at,
      this.updated_at,
      this.active_status);

  Blog copyWith({
    int? id,
    Account? owner,
    String? title,
    String? description,
    String? image_url,
    String? content,
    String? benefit,
    List<BlogVote>? votes,
    String? created_at,
    String? updated_at,
    int? active_status,
  }) {
    return Blog(
      id ?? this.id,
      owner ?? this.owner,
      title ?? this.title,
      description ?? this.description,
      image_url ?? this.image_url,
      content ?? this.content,
      benefit ?? this.benefit,
      votes ?? this.votes,
      created_at ?? this.created_at,
      updated_at ?? this.updated_at,
      active_status ?? this.active_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner.toMap(),
      'title': title,
      'description': description,
      'image_url': image_url,
      'content': content,
      'benefit': benefit,
      'votes': votes.map((x) => x.toMap()).toList(),
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      map['id'] as int,
      Account.fromMap(map['owner'] as Map<String, dynamic>),
      map['title'] as String,
      map['description'] as String,
      map['image_url'] as String,
      map['content'] as String,
      map['benefit'] as String,
      List<BlogVote>.from(
        (map['votes'] as List<dynamic>).map<BlogVote>(
          (x) => BlogVote.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['created_at'] as String,
      map['updated_at'] as String,
      map['active_status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Blog.fromJson(String source) =>
      Blog.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Blog(id: $id, owner: $owner, title: $title, description: $description, image_url: $image_url, content: $content, benefit: $benefit, votes: $votes, created_at: $created_at, updated_at: $updated_at, active_status: $active_status)';
  }

  @override
  bool operator ==(covariant Blog other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.owner == owner &&
        other.title == title &&
        other.description == description &&
        other.image_url == image_url &&
        other.content == content &&
        other.benefit == benefit &&
        listEquals(other.votes, votes) &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        owner.hashCode ^
        title.hashCode ^
        description.hashCode ^
        image_url.hashCode ^
        content.hashCode ^
        benefit.hashCode ^
        votes.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode;
  }
}
