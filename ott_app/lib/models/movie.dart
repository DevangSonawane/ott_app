class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.type,
    required this.description,
    required this.image,
    this.bannerImage = '',
    this.videoUrl,
    this.trailer,
    this.rating,
    this.duration,
    this.progress,
    this.episodeInfo,
    this.cast = const <String>[],
    this.creators = const <String>[],
    this.totalEpisodes,
    this.episodes = const <Episode>[],
  });

  final String id;
  final String title;
  final int year;
  final List<String> genre;
  final String type; // 'movie' | 'series'
  final String description;
  final String image; // Asset path or network URL
  final String bannerImage; // Wide backdrop for detail headers
  final String? videoUrl; // Direct stream URL (mp4/hls), if available
  final String? trailer; // Trailer URL (typically YouTube), if available
  final double? rating; // 0.0–1.0
  final String? duration;
  final int? progress; // 0–100, for continue-watching
  final EpisodeInfo? episodeInfo;
  final List<String> cast;
  final List<String> creators;
  final int? totalEpisodes;
  final List<Episode> episodes; // First-season episodes (best-effort)

  Movie copyWith({
    String? id,
    String? title,
    int? year,
    List<String>? genre,
    String? type,
    String? description,
    String? image,
    String? bannerImage,
    String? videoUrl,
    String? trailer,
    double? rating,
    String? duration,
    int? progress,
    EpisodeInfo? episodeInfo,
    List<String>? cast,
    List<String>? creators,
    int? totalEpisodes,
    List<Episode>? episodes,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      type: type ?? this.type,
      description: description ?? this.description,
      image: image ?? this.image,
      bannerImage: bannerImage ?? this.bannerImage,
      videoUrl: videoUrl ?? this.videoUrl,
      trailer: trailer ?? this.trailer,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      episodeInfo: episodeInfo ?? this.episodeInfo,
      cast: cast ?? this.cast,
      creators: creators ?? this.creators,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      episodes: episodes ?? this.episodes,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    final castRaw = (json['cast'] as List<dynamic>?) ?? const <dynamic>[];
    final creatorsRaw =
        (json['creators'] as List<dynamic>?) ?? const <dynamic>[];
    final episodesRaw =
        (json['episodes'] as List<dynamic>?) ?? const <dynamic>[];

    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      year: (json['year'] as num).toInt(),
      genre: (json['genre'] as List<dynamic>).cast<String>(),
      type: json['type'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      bannerImage: (json['bannerImage'] ?? '').toString(),
      videoUrl: json['videoUrl'] as String?,
      trailer: json['trailer'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      duration: json['duration'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
      episodeInfo: json['episodeInfo'] == null
          ? null
          : EpisodeInfo.fromJson(json['episodeInfo'] as Map<String, dynamic>),
      cast: castRaw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList(),
      creators: creatorsRaw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList(),
      totalEpisodes: (json['totalEpisodes'] as num?)?.toInt(),
      episodes: episodesRaw
          .whereType<Map<String, dynamic>>()
          .map(Episode.fromJson)
          .toList(growable: false),
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
      'bannerImage': bannerImage,
      'videoUrl': videoUrl,
      'trailer': trailer,
      'rating': rating,
      'duration': duration,
      'progress': progress,
      'episodeInfo': episodeInfo?.toJson(),
      'cast': cast,
      'creators': creators,
      'totalEpisodes': totalEpisodes,
      'episodes': episodes.map((e) => e.toJson()).toList(growable: false),
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

class Episode {
  const Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.thumbnail,
    this.durationSeconds,
  });

  final String id;
  final int number;
  final String title;
  final String description;
  final String thumbnail;
  final int? durationSeconds;

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: (json['id'] ?? '').toString(),
      number: (json['number'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? '').toString(),
      durationSeconds: (json['duration'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'duration': durationSeconds,
    };
  }
}
