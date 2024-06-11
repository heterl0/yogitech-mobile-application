
import 'pose.dart';


class ExercisePose {
  Pose pose;
  Exercise exercise;
  int time;
  int duration;

  ExercisePose({
    required this.pose,
    required this.exercise,
    required this.time,
    required this.duration,
  });

  factory ExercisePose.fromJson(Map<String, dynamic> json) {
    return ExercisePose(
      pose: Pose.fromJson(json['pose']),
      exercise: Exercise.fromJson(json['exercise']),
      time: json['time'],
      duration: json['duration'],
    );
  }
}
class Exercise {
  int id;
  String title;
  int? level;
  List<String>? benefit;
  String? description;
  double? calories;
  int? numberPoses;
  int? point;
  bool? isPremium;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? owner;
  int? activeStatus;
  List<ExercisePose>? poses;
  String? videoUrl;
  String? imageUrl;
  int? durations;
  List<dynamic>? comments;

  Exercise({
    required this.id,
    required this.title,
    this.level,
    this.benefit,
    this.description,
    this.calories,
    this.numberPoses,
    this.point,
    this.isPremium,
    this.createdAt,
    this.updatedAt,
    this.owner,
    this.activeStatus,
    this.poses,
    this.videoUrl,
    this.imageUrl,
    this.durations,
    this.comments,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      title: json['title'],
      level: json['level'],
      benefit: (json['benefit'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      description: json['description'] as String?,
      calories: json['calories'] != null ? double.parse(json['calories'].toString()) : null,
      numberPoses: json['number_poses'],
      point: json['point'],
      isPremium: json['is_premium'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      owner: json['owner'],
      activeStatus: json['active_status'],
      poses: (json['poses'] as List<dynamic>?)?.map((e) => ExercisePose.fromJson(e)).toList(),
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
      durations: json['durations'],
      comments: json['comments'],
    );
  }
}

