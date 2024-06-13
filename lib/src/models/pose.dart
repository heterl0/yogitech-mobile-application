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
}
