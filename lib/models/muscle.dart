class Muscle {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int activeStatus;

  Muscle({
    this.id,
    this.name,
    this.image,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.activeStatus = 1,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
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
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'active_status': activeStatus,
    };
  }
}
