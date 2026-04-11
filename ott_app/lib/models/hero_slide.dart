class HeroSlide {
  const HeroSlide({
    required this.id,
    required this.title,
    required this.meta,
    required this.description,
    required this.image,
  });

  final String id;
  final String title;
  final String meta; // e.g. "2016 | Sci-Fi | Horror"
  final String description;
  final String image;

  HeroSlide copyWith({
    String? id,
    String? title,
    String? meta,
    String? description,
    String? image,
  }) {
    return HeroSlide(
      id: id ?? this.id,
      title: title ?? this.title,
      meta: meta ?? this.meta,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  factory HeroSlide.fromJson(Map<String, dynamic> json) {
    return HeroSlide(
      id: json['id'] as String,
      title: json['title'] as String,
      meta: json['meta'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'meta': meta,
      'description': description,
      'image': image,
    };
  }
}
