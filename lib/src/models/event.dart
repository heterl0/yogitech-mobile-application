// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Event {
  int id;
  String title;
  String image_url;
  int status;
  String start_date;
  String expire_date;
  String description;
  int active_status;
  List<Exercise> exercises;
  List<CandidateEvent> event_candidate;
  Account owner;
  String created_at;

  Event({
    required this.id,
    required this.title,
    required this.image_url,
    required this.status,
    required this.start_date,
    required this.expire_date,
    required this.description,
    required this.active_status,
    required this.exercises,
    required this.event_candidate,
    required this.owner,
    required this.created_at,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      image_url: json['image_url'],
      status: json['status'],
      start_date: json['start_date'],
      expire_date: json['expire_date'],
      description: json['description'],
      active_status: json['active_status'],
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
      event_candidate: (json['event_candidate'] as List)
          .map((e) => CandidateEvent.fromJson(e))
          .toList(),
      owner: Account.fromJson(json['owner']),
      created_at: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': image_url,
      'status': status,
      'start_date': start_date,
      'expire_date': expire_date,
      'description': description,
      'active_status': active_status,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'event_candidate': event_candidate.map((e) => e.toJson()).toList(),
      'owner': owner.toJson(),
      'created_at': created_at,
    };
  }

  Event copyWith({
    int? id,
    String? title,
    String? image_url,
    int? status,
    String? start_date,
    String? expire_date,
    String? description,
    int? active_status,
    List<Exercise>? exercises,
    List<CandidateEvent>? event_candidate,
    Account? owner,
    String? created_at,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      image_url: image_url ?? this.image_url,
      status: status ?? this.status,
      start_date: start_date ?? this.start_date,
      expire_date: expire_date ?? this.expire_date,
      description: description ?? this.description,
      active_status: active_status ?? this.active_status,
      exercises: exercises ?? this.exercises,
      event_candidate: event_candidate ?? this.event_candidate,
      owner: owner ?? this.owner,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image_url': image_url,
      'status': status,
      'start_date': start_date,
      'expire_date': expire_date,
      'description': description,
      'active_status': active_status,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'event_candidate': event_candidate.map((x) => x.toMap()).toList(),
      'owner': owner.toMap(),
      'created_at': created_at,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      title: map['title'] as String,
      image_url: map['image_url'] as String,
      status: map['status'] as int,
      start_date: map['start_date'] as String,
      expire_date: map['expire_date'] as String,
      description: map['description'] as String,
      active_status: map['active_status'] as int,
      exercises: List<Exercise>.from(
        (map['exercises'] as List<int>).map<Exercise>(
          (x) => Exercise.fromMap(x as Map<String, dynamic>),
        ),
      ),
      event_candidate: List<CandidateEvent>.from(
        (map['event_candidate'] as List<int>).map<CandidateEvent>(
          (x) => CandidateEvent.fromMap(x as Map<String, dynamic>),
        ),
      ),
      owner: Account.fromMap(map['owner'] as Map<String, dynamic>),
      created_at: map['created_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(id: $id, title: $title, image_url: $image_url, status: $status, start_date: $start_date, expire_date: $expire_date, description: $description, active_status: $active_status, exercises: $exercises, event_candidate: $event_candidate, owner: $owner, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.image_url == image_url &&
        other.status == status &&
        other.start_date == start_date &&
        other.expire_date == expire_date &&
        other.description == description &&
        other.active_status == active_status &&
        listEquals(other.exercises, exercises) &&
        listEquals(other.event_candidate, event_candidate) &&
        other.owner == owner &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        image_url.hashCode ^
        status.hashCode ^
        start_date.hashCode ^
        expire_date.hashCode ^
        description.hashCode ^
        active_status.hashCode ^
        exercises.hashCode ^
        event_candidate.hashCode ^
        owner.hashCode ^
        created_at.hashCode;
  }
}

class CandidateEvent {
  int id;
  Account user;
  int event_point;
  int active_status;
  String join_at;
  String updated_at;
  int event;

  CandidateEvent({
    required this.id,
    required this.user,
    required this.event_point,
    required this.active_status,
    required this.join_at,
    required this.updated_at,
    required this.event,
  });

  factory CandidateEvent.fromJson(Map<String, dynamic> json) {
    return CandidateEvent(
      id: json['id'],
      user: Account.fromJson(json['user']),
      event_point: json['event_point'],
      active_status: json['active_status'],
      join_at: json['join_at'],
      updated_at: json['updated_at'],
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'event_point': event_point,
      'active_status': active_status,
      'join_at': join_at,
      'updated_at': updated_at,
      'event': event,
    };
  }

  CandidateEvent copyWith({
    int? id,
    Account? user,
    int? event_point,
    int? active_status,
    String? join_at,
    String? updated_at,
    int? event,
  }) {
    return CandidateEvent(
      id: id ?? this.id,
      user: user ?? this.user,
      event_point: event_point ?? this.event_point,
      active_status: active_status ?? this.active_status,
      join_at: join_at ?? this.join_at,
      updated_at: updated_at ?? this.updated_at,
      event: event ?? this.event,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'event_point': event_point,
      'active_status': active_status,
      'join_at': join_at,
      'updated_at': updated_at,
      'event': event,
    };
  }

  factory CandidateEvent.fromMap(Map<String, dynamic> map) {
    return CandidateEvent(
      id: map['id'] as int,
      user: Account.fromMap(map['user'] as Map<String, dynamic>),
      event_point: map['event_point'] as int,
      active_status: map['active_status'] as int,
      join_at: map['join_at'] as String,
      updated_at: map['updated_at'] as String,
      event: map['event'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CandidateEvent.fromJson(String source) =>
      CandidateEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CandidateEvent(id: $id, user: $user, event_point: $event_point, active_status: $active_status, join_at: $join_at, updated_at: $updated_at, event: $event)';
  }

  @override
  bool operator ==(covariant CandidateEvent other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.event_point == event_point &&
        other.active_status == active_status &&
        other.join_at == join_at &&
        other.updated_at == updated_at &&
        other.event == event;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        event_point.hashCode ^
        active_status.hashCode ^
        join_at.hashCode ^
        updated_at.hashCode ^
        event.hashCode;
  }
}

// Placeholder for Exercise class. You need to replace this with the actual implementation.
class Exercise {
  Exercise();

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

// Placeholder for Account class. You need to replace this with the actual implementation.
class Account {
  Account();

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
