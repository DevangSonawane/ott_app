class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isKids,
  });

  final String id;
  final String name;
  final String avatar;
  final bool isKids;

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isKids,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isKids: isKids ?? this.isKids,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      isKids: json['isKids'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isKids': isKids,
    };
  }
}
