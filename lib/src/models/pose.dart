// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Muscle {
  int id;
  String name;
  String image;
  String description;
  String created_at;
  String updated_at;
  int active_status;

  Muscle({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.created_at,
    required this.updated_at,
    required this.active_status,
  });

  Muscle copyWith({
    int? id,
    String? name,
    String? image,
    String? description,
    String? created_at,
    String? updated_at,
    int? active_status,
  }) {
    return Muscle(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      active_status: active_status ?? this.active_status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
    };
  }

  factory Muscle.fromMap(Map<String, dynamic> map) {
    return Muscle(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      active_status: map['active_status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Muscle.fromJson(String source) =>
      Muscle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Muscle(id: $id, name: $name, image: $image, description: $description, created_at: $created_at, updated_at: $updated_at, active_status: $active_status)';
  }

  @override
  bool operator ==(covariant Muscle other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.image == image &&
        other.description == description &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        description.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode;
  }
}

class Pose {
  int id;
  List<Muscle> muscles;
  String name;
  String image_url;
  int duration;
  int calories;
  String keypoint_url;
  String instruction;
  String created_at;
  String updated_at;
  int active_status;
  int level;

  Pose({
    required this.id,
    required this.muscles,
    required this.name,
    required this.image_url,
    required this.duration,
    required this.calories,
    required this.keypoint_url,
    required this.instruction,
    required this.created_at,
    required this.updated_at,
    required this.active_status,
    required this.level,
  });

  Pose copyWith({
    int? id,
    List<Muscle>? muscles,
    String? name,
    String? image_url,
    int? duration,
    int? calories,
    String? keypoint_url,
    String? instruction,
    String? created_at,
    String? updated_at,
    int? active_status,
    int? level,
  }) {
    return Pose(
      id: id ?? this.id,
      muscles: muscles ?? this.muscles,
      name: name ?? this.name,
      image_url: image_url ?? this.image_url,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      keypoint_url: keypoint_url ?? this.keypoint_url,
      instruction: instruction ?? this.instruction,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      active_status: active_status ?? this.active_status,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'muscles': muscles.map((x) => x.toMap()).toList(),
      'name': name,
      'image_url': image_url,
      'duration': duration,
      'calories': calories,
      'keypoint_url': keypoint_url,
      'instruction': instruction,
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
      'level': level,
    };
  }

  factory Pose.fromMap(Map<String, dynamic> map) {
    return Pose(
      id: map['id'] as int,
      muscles: List<Muscle>.from(
        (map['muscles'] as List<int>).map<Muscle>(
          (x) => Muscle.fromMap(x as Map<String, dynamic>),
        ),
      ),
      name: map['name'] as String,
      image_url: map['image_url'] as String,
      duration: map['duration'] as int,
      calories: map['calories'] as int,
      keypoint_url: map['keypoint_url'] as String,
      instruction: map['instruction'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      active_status: map['active_status'] as int,
      level: map['level'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pose.fromJson(String source) =>
      Pose.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pose(id: $id, muscles: $muscles, name: $name, image_url: $image_url, duration: $duration, calories: $calories, keypoint_url: $keypoint_url, instruction: $instruction, created_at: $created_at, updated_at: $updated_at, active_status: $active_status, level: $level)';
  }

  @override
  bool operator ==(covariant Pose other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        listEquals(other.muscles, muscles) &&
        other.name == name &&
        other.image_url == image_url &&
        other.duration == duration &&
        other.calories == calories &&
        other.keypoint_url == keypoint_url &&
        other.instruction == instruction &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        muscles.hashCode ^
        name.hashCode ^
        image_url.hashCode ^
        duration.hashCode ^
        calories.hashCode ^
        keypoint_url.hashCode ^
        instruction.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode ^
        level.hashCode;
  }
}
