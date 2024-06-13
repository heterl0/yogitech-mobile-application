import 'package:yogi_application/src/models/owner.dart';

class Example {
  int? id;
  Owner? owner;
  String? title;
  String? description;
  String? imageUrl;
  String? content;
  String? benefit;
  List<dynamic>? votes;
  String? createdAt;
  String? updatedAt;
  int? activeStatus;

  Example(
      {this.id,
      this.owner,
      this.title,
      this.description,
      this.imageUrl,
      this.content,
      this.benefit,
      this.votes,
      this.createdAt,
      this.updatedAt,
      this.activeStatus});

  Example.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["owner"] is Map) {
      owner = json["owner"] == null ? null : Owner.fromJson(json["owner"]);
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["image_url"] is String) {
      imageUrl = json["image_url"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["benefit"] is String) {
      benefit = json["benefit"];
    }
    if (json["votes"] is List) {
      votes = json["votes"] ?? [];
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
    if (owner != null) {
      _data["owner"] = owner?.toJson();
    }
    _data["title"] = title;
    _data["description"] = description;
    _data["image_url"] = imageUrl;
    _data["content"] = content;
    _data["benefit"] = benefit;
    if (votes != null) {
      _data["votes"] = votes;
    }
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["active_status"] = activeStatus;
    return _data;
  }
}
