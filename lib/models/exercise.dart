// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/models/pose.dart';

class PoseWithTime {
  Pose pose;
  int time;
  int duration;

  PoseWithTime({
    required this.pose,
    required this.time,
    required this.duration,
  });

  PoseWithTime copyWith({
    Pose? pose,
    int? time,
    int? duration,
  }) {
    return PoseWithTime(
      pose: pose ?? this.pose,
      time: time ?? this.time,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pose': pose.toMap(),
      'time': time,
      'duration': duration,
    };
  }

  factory PoseWithTime.fromMap(Map<String, dynamic> map) {
    return PoseWithTime(
      pose: Pose.fromMap(map['pose'] as Map<String, dynamic>),
      time: map['time'] as int,
      duration: map['duration'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PoseWithTime.fromJson(String source) =>
      PoseWithTime.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PoseWithTime(pose: $pose, time: $time, duration: $duration)';

  @override
  bool operator ==(covariant PoseWithTime other) {
    if (identical(this, other)) return true;
    return other.pose == pose &&
        other.time == time &&
        other.duration == duration;
  }

  @override
  int get hashCode => pose.hashCode ^ time.hashCode ^ duration.hashCode;
}

class Exercise {
  int id;
  String title;
  String? image_url;
  String? video_url;
  int? durations;
  int level;
  String? benefit;
  String? description;
  String calories;
  int number_poses;
  int point;
  bool is_premium;
  String created_at;
  String updated_at;
  dynamic owner;
  int active_status;
  List<PoseWithTime> poses;
  List<Comment> comments;
  bool? is_admin;

  Exercise({
    required this.id,
    required this.title,
    this.image_url,
    this.video_url,
    required this.durations,
    required this.level,
    this.benefit,
    this.description,
    required this.calories,
    required this.number_poses,
    required this.point,
    required this.is_premium,
    required this.created_at,
    required this.updated_at,
    this.owner,
    required this.active_status,
    required this.poses,
    required this.comments,
    this.is_admin,
  });

  Exercise copyWith({
    int? id,
    String? title,
    String? image_url,
    String? video_url,
    int? durations,
    int? level,
    String? benefit,
    String? description,
    String? calories,
    int? number_poses,
    int? point,
    bool? is_premium,
    String? created_at,
    String? updated_at,
    dynamic owner,
    int? active_status,
    List<PoseWithTime>? poses,
    List<Comment>? comments,
    bool? is_admin,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      image_url: image_url ?? this.image_url,
      video_url: video_url ?? this.video_url,
      durations: durations ?? this.durations,
      level: level ?? this.level,
      benefit: benefit ?? this.benefit,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      number_poses: number_poses ?? this.number_poses,
      point: point ?? this.point,
      is_premium: is_premium ?? this.is_premium,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      owner: owner ?? this.owner,
      active_status: active_status ?? this.active_status,
      poses: poses ?? this.poses,
      comments: comments ?? this.comments,
      is_admin: is_admin ?? this.is_admin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image_url': image_url,
      'video_url': video_url,
      'durations': durations,
      'level': level,
      'benefit': benefit,
      'description': description,
      'calories': calories,
      'number_poses': number_poses,
      'point': point,
      'is_premium': is_premium,
      'created_at': created_at,
      'updated_at': updated_at,
      'owner': owner,
      'active_status': active_status,
      'poses': poses.map((x) => x.toMap()).toList(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'is_admin': is_admin,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int,
      title: map['title'] as String,
      image_url: map['image_url'] != null ? map['image_url'] as String : "",
      video_url: map['video_url'] != null ? map['video_url'] as String : "",
      durations: map['durations'] ?? 0,
      level: map['level'] as int,
      benefit: map['benefit'] != null ? map['benefit'] as String : "",
      description:
          map['description'] != null ? map['description'] as String : "",
      calories: map['calories'] as String,
      number_poses: map['number_poses'] as int,
      point: map['point'] as int,
      is_premium: map['is_premium'] as bool,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      owner: map['owner'] as dynamic,
      active_status: map['active_status'] as int,
      poses: List<PoseWithTime>.from(
        (map['poses'] as List<dynamic>).map<PoseWithTime>(
          (x) => PoseWithTime.fromMap(x as Map<String, dynamic>),
        ),
      ),
      comments: List<Comment>.from(
        (map['comments'] as List<dynamic>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      is_admin: map['is_admin'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Exercise.fromJson(String source) =>
      Exercise.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Exercise(id: $id, title: $title, image_url: $image_url, video_url: $video_url, durations: $durations, level: $level, benefit: $benefit, description: $description, calories: $calories, number_poses: $number_poses, point: $point, is_premium: $is_premium, created_at: $created_at, updated_at: $updated_at, owner: $owner, active_status: $active_status, poses: $poses, comments: $comments, is_admin: $is_admin)';
  }

  @override
  bool operator ==(covariant Exercise other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.image_url == image_url &&
        other.video_url == video_url &&
        other.durations == durations &&
        other.level == level &&
        other.benefit == benefit &&
        other.description == description &&
        other.calories == calories &&
        other.number_poses == number_poses &&
        other.point == point &&
        other.is_premium == is_premium &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.owner == owner &&
        other.active_status == active_status &&
        listEquals(other.poses, poses) &&
        listEquals(other.comments, comments) &&
        other.is_admin == is_admin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        image_url.hashCode ^
        video_url.hashCode ^
        durations.hashCode ^
        level.hashCode ^
        benefit.hashCode ^
        description.hashCode ^
        calories.hashCode ^
        number_poses.hashCode ^
        point.hashCode ^
        is_premium.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        owner.hashCode ^
        active_status.hashCode ^
        poses.hashCode ^
        comments.hashCode ^
        is_admin.hashCode;
  }
}

class Vote {
  int id;
  String user;
  int user_id;
  int vote_value;
  int comment;

  Vote({
    required this.id,
    required this.user,
    required this.user_id,
    required this.vote_value,
    required this.comment,
  });

  Vote copyWith({
    int? id,
    String? user,
    int? user_id,
    int? vote_value,
    int? comment,
  }) {
    return Vote(
      id: id ?? this.id,
      user: user ?? this.user,
      user_id: user_id ?? this.user_id,
      vote_value: vote_value ?? this.vote_value,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'user_id': user_id,
      'vote_value': vote_value,
      'comment': comment,
    };
  }

  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      id: map['id'] as int,
      user: map['user'] as String,
      user_id: map['user_id'] as int,
      vote_value: map['vote_value'] as int,
      comment: map['comment'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vote.fromJson(String source) =>
      Vote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vote(id: $id, user: $user, user_id: $user_id, vote_value: $vote_value, comment: $comment)';
  }

  @override
  bool operator ==(covariant Vote other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.user_id == user_id &&
        other.vote_value == vote_value &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        user_id.hashCode ^
        vote_value.hashCode ^
        comment.hashCode;
  }
}

class Comment {
  int id;
  List<Vote> votes;
  String text;
  String created_at;
  String updated_at;
  int active_status;
  int? parent_comment;
  Account user;
  int exercise;

  Comment({
    required this.id,
    required this.votes,
    required this.text,
    required this.created_at,
    required this.updated_at,
    required this.active_status,
    required this.parent_comment,
    required this.user,
    required this.exercise,
  });

  Comment copyWith({
    int? id,
    List<Vote>? votes,
    String? text,
    String? created_at,
    String? updated_at,
    int? active_status,
    int? parent_comment,
    Account? user,
    int? exercise,
  }) {
    return Comment(
      id: id ?? this.id,
      votes: votes ?? this.votes,
      text: text ?? this.text,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      active_status: active_status ?? this.active_status,
      parent_comment: parent_comment ?? this.parent_comment,
      user: user ?? this.user,
      exercise: exercise ?? this.exercise,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'votes': votes.map((x) => x.toMap()).toList(),
      'text': text,
      'created_at': created_at,
      'updated_at': updated_at,
      'active_status': active_status,
      'parent_comment': parent_comment,
      'user': user.toMap(),
      'exercise': exercise,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int,
      votes: map['votes'] != null
          ? List<Vote>.from(
              (map['votes'] as List<dynamic>).map<Vote>(
                (x) => Vote.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      text: map['text'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      active_status: map['active_status'] as int,
      parent_comment:
          map['parent_comment'] != null ? map['parent_comment'] as int : null,
      user: Account.fromMap(map['user'] as Map<String, dynamic>),
      exercise: map['exercise'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, votes: $votes, text: $text, created_at: $created_at, updated_at: $updated_at, active_status: $active_status, parent_comment: $parent_comment, user: $user, exercise: $exercise)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.votes, votes) &&
        other.text == text &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.active_status == active_status &&
        other.parent_comment == parent_comment &&
        other.user == user &&
        other.exercise == exercise;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        votes.hashCode ^
        text.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        active_status.hashCode ^
        parent_comment.hashCode ^
        user.hashCode ^
        exercise.hashCode;
  }

  bool hasUserVoted(int userId) {
    for (Vote vote in votes) {
      if (vote.user_id == userId) {
        return true;
      }
    }
    return false;
  }

  Vote? getUserVote(int userId) {
    for (Vote vote in votes) {
      if (vote.user_id == userId) {
        return vote;
      }
    }
    return null;
  }
}

class ExerciseResult {
  final int exercise;
  final int user;
  final String process;
  final int completePose;
  final String result;
  final int point;
  final int exp;
  final String calories;
  final List<ExercisePoseResult> exercisePoseResults;
  final int totalTimeFinish;
  final String createdAt;
  final String updatedAt;
  final dynamic event; // Assuming event can be various types or null
  final int activeStatus;

  ExerciseResult({
    required this.exercise,
    required this.user,
    required this.process,
    required this.completePose,
    required this.result,
    required this.point,
    required this.exp,
    required this.calories,
    required this.exercisePoseResults,
    required this.totalTimeFinish,
    required this.createdAt,
    required this.updatedAt,
    this.event,
    required this.activeStatus,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      exercise: json['exercise'],
      user: json['user'],
      process: json['process'],
      completePose: json['complete_pose'],
      result: json['result'],
      point: json['point'],
      exp: json['exp'],
      calories: json['calories'],
      exercisePoseResults: (json['exercise_pose_results'] as List)
          .map((i) => ExercisePoseResult.fromJson(i))
          .toList(),
      totalTimeFinish: json['total_time_finish'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      event: json['event'],
      activeStatus: json['active_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise,
      'user': user,
      'process': process,
      'complete_pose': completePose,
      'result': result,
      'point': point,
      'exp': exp,
      'calories': calories,
      'exercise_pose_results':
          exercisePoseResults.map((i) => i.toJson()).toList(),
      'total_time_finish': totalTimeFinish,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'event': event,
      'active_status': activeStatus,
    };
  }
}

class ExercisePoseResult {
  final int pose;
  final String score;
  final int timeFinish;

  ExercisePoseResult({
    required this.pose,
    required this.score,
    required this.timeFinish,
  });

  factory ExercisePoseResult.fromJson(Map<String, dynamic> json) {
    return ExercisePoseResult(
      pose: json['pose'],
      score: json['score'],
      timeFinish: json['time_finish'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pose': pose,
      'score': score,
      'time_finish': timeFinish,
    };
  }
}
