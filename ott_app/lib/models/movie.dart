class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.type,
    required this.description,
    required this.image,
    this.rating,
    this.duration,
    this.progress,
    this.episodeInfo,
  });

  final String id;
  final String title;
  final int year;
  final List<String> genre;
  final String type; // 'movie' | 'series'
  final String description;
  final String image; // Asset path or network URL
  final double? rating; // 0.0–1.0
  final String? duration;
  final int? progress; // 0–100, for continue-watching
  final EpisodeInfo? episodeInfo;

  Movie copyWith({
    String? id,
    String? title,
    int? year,
    List<String>? genre,
    String? type,
    String? description,
    String? image,
    double? rating,
    String? duration,
    int? progress,
    EpisodeInfo? episodeInfo,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      type: type ?? this.type,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      episodeInfo: episodeInfo ?? this.episodeInfo,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      year: (json['year'] as num).toInt(),
      genre: (json['genre'] as List<dynamic>).cast<String>(),
      type: json['type'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      duration: json['duration'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
      episodeInfo: json['episodeInfo'] == null
          ? null
          : EpisodeInfo.fromJson(json['episodeInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'genre': genre,
      'type': type,
      'description': description,
      'image': image,
      'rating': rating,
      'duration': duration,
      'progress': progress,
      'episodeInfo': episodeInfo?.toJson(),
    };
  }
}

class EpisodeInfo {
  const EpisodeInfo({
    required this.season,
    required this.episode,
    required this.episodeTitle,
  });

  final int season;
  final int episode;
  final String episodeTitle;

  EpisodeInfo copyWith({
    int? season,
    int? episode,
    String? episodeTitle,
  }) {
    return EpisodeInfo(
      season: season ?? this.season,
      episode: episode ?? this.episode,
      episodeTitle: episodeTitle ?? this.episodeTitle,
    );
  }

  factory EpisodeInfo.fromJson(Map<String, dynamic> json) {
    return EpisodeInfo(
      season: (json['season'] as num).toInt(),
      episode: (json['episode'] as num).toInt(),
      episodeTitle: json['episodeTitle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'episode': episode,
      'episodeTitle': episodeTitle,
    };
  }
}
