import 'muscle.dart';
import 'level.dart';

class Pose {
  final int? id;
  final String? name;
  final String? image;
  final int? duration;
  final Level? level;
  final double? calories;
  final String? keypoint;
  final String? instruction;
  final List<Muscle>? muscles;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int activeStatus;

  Pose({
    this.id,
    this.name,
    this.image,
    this.duration,
    this.level,
    this.calories,
    this.keypoint,
    this.instruction,
    this.muscles,
    this.createdAt,
    this.updatedAt,
    this.activeStatus = 1,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    var muscleList = json['muscles'] as List;
    List<Muscle> musclesList = muscleList.map((i) => Muscle.fromJson(i)).toList();

    return Pose(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      duration: json['duration'],
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
      calories: json['calories']?.toDouble(),
      keypoint: json['keypoint'],
      instruction: json['instruction'],
      muscles: musclesList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      activeStatus: json['active_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'duration': duration,
      'level': level?.toJson(),
      'calories': calories,
      'keypoint': keypoint,
      'instruction': instruction,
      'muscles': muscles?.map((m) => m.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'active_status': activeStatus,
    };
  }
}

