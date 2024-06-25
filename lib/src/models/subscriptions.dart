import 'dart:convert';

class Subscription {
  final int id;
  final String name;
  final double price;
  final int? gemPrice;
  final String description;
  final String duration;
  final double durationInMonth;
  final bool valid;
  final String createdAt;
  final String updatedAt;
  final int activeStatus;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    this.gemPrice,
    required this.description,
    required this.duration,
    required this.durationInMonth,
    required this.valid,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
  });

  Subscription copyWith({
    int? id,
    String? name,
    double? price,
    int? gemPrice,
    String? description,
    String? duration,
    double? durationInMonth,
    bool? valid,
    String? createdAt,
    String? updatedAt,
    int? activeStatus,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      gemPrice: gemPrice ?? this.gemPrice,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      durationInMonth: durationInMonth ?? this.durationInMonth,
      valid: valid ?? this.valid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      activeStatus: activeStatus ?? this.activeStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'gem_price': gemPrice,
      'description': description,
      'duration': duration,
      'duration_in_month': durationInMonth,
      'valid': valid,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'active_status': activeStatus,
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      gemPrice: map['gem_price'] != null ? map['gem_price'] as int : null,
      description: map['description'] as String,
      duration: map['duration'] as String,
      durationInMonth: map['duration_in_month'] as double,
      valid: map['valid'] as bool,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      activeStatus: map['active_status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(String source) => Subscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Subscription(id: $id, name: $name, price: $price, gemPrice: $gemPrice, description: $description, duration: $duration, durationInMonth: $durationInMonth, valid: $valid, createdAt: $createdAt, updatedAt: $updatedAt, activeStatus: $activeStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.gemPrice == gemPrice &&
        other.description == description &&
        other.duration == duration &&
        other.durationInMonth == durationInMonth &&
        other.valid == valid &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.activeStatus == activeStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        gemPrice.hashCode ^
        description.hashCode ^
        duration.hashCode ^
        durationInMonth.hashCode ^
        valid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        activeStatus.hashCode;
  }
}

class UserSubscription {
  final int id;
  final int userId;
  final Subscription subscription;
  final String subscriptionType;
  final int status;
  final String? cancelAt;
  final String createdAt;
  final String expireDate;
  final String updatedAt;
  final int activeStatus;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.subscription,
    required this.subscriptionType,
    required this.status,
    this.cancelAt,
    required this.createdAt,
    required this.expireDate,
    required this.updatedAt,
    required this.activeStatus,
  });

  UserSubscription copyWith({
    int? id,
    int? userId,
    Subscription? subscription,
    String? subscriptionType,
    int? status,
    String? cancelAt,
    String? createdAt,
    String? expireDate,
    String? updatedAt,
    int? activeStatus,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subscription: subscription ?? this.subscription,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      status: status ?? this.status,
      cancelAt: cancelAt ?? this.cancelAt,
      createdAt: createdAt ?? this.createdAt,
      expireDate: expireDate ?? this.expireDate,
      updatedAt: updatedAt ?? this.updatedAt,
      activeStatus: activeStatus ?? this.activeStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subscription': subscription.toMap(),
      'subscription_type': subscriptionType,
      'status': status,
      'cancel_at': cancelAt,
      'created_at': createdAt,
      'expire_date': expireDate,
      'updated_at': updatedAt,
      'active_status': activeStatus,
    };
  }

  factory UserSubscription.fromMap(Map<String, dynamic> map) {
    return UserSubscription(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      subscription: Subscription.fromMap(map['subscription'] as Map<String, dynamic>),
      subscriptionType: map['subscription_type'] as String,
      status: map['status'] as int,
      cancelAt: map['cancel_at'] as String?,
      createdAt: map['created_at'] as String,
      expireDate: map['expire_date'] as String,
      updatedAt: map['updated_at'] as String,
      activeStatus: map['active_status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSubscription.fromJson(String source) => UserSubscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserSubscription(id: $id, userId: $userId, subscription: $subscription, subscriptionType: $subscriptionType, status: $status, cancelAt: $cancelAt, createdAt: $createdAt, expireDate: $expireDate, updatedAt: $updatedAt, activeStatus: $activeStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserSubscription &&
        other.id == id &&
        other.userId == userId &&
        other.subscription == subscription &&
        other.subscriptionType == subscriptionType &&
        other.status == status &&
        other.cancelAt == cancelAt &&
        other.createdAt == createdAt &&
        other.expireDate == expireDate &&
        other.updatedAt == updatedAt &&
        other.activeStatus == activeStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        subscription.hashCode ^
        subscriptionType.hashCode ^
        status.hashCode ^
        cancelAt.hashCode ^
        createdAt.hashCode ^
        expireDate.hashCode ^
        updatedAt.hashCode ^
        activeStatus.hashCode;
  }
}
