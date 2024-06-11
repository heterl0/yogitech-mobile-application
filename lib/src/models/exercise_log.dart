import 'exercise.dart';

class ExerciseLog {
  int id;
  int user;
  Exercise exercise;
  double? process;
  int? completePose;
  double? point;
  String? result;
  int? event;
  DateTime createdAt;
  DateTime updatedAt;
  int activeStatus;

  ExerciseLog({
    required this.id,
    required this.user,
    required this.exercise,
    this.process,
    this.completePose,
    this.point,
    this.result,
    this.event,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      id: json['id'],
      user: json['user'],
      exercise: Exercise.fromJson(json['exercise']),
      process: json['process'],
      completePose: json['complete_pose'],
      point: json['point'],
      result: json['result'],
      event: json['event'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activeStatus: json['active_status'],
    );
  }
}
