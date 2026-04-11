import 'package:flutter/material.dart';

class Genre {
  const Genre({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final String icon; // icon name mapping to Flutter icon
  final Color color;

  Genre copyWith({
    String? id,
    String? name,
    String? icon,
    Color? color,
  }) {
    return Genre(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: Color((json['color'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value,
    };
  }
}
