import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hero_slide.dart';
import '../models/movie.dart';
import '../models/user_profile.dart';
import '../data/content_data.dart';
import 'app_content_provider.dart';

class ContentState {
  const ContentState({
    required this.selectedProfile,
    required this.selectedMovie,
    required this.currentHeroSlide,
  });

  final UserProfile? selectedProfile;
  final Movie? selectedMovie;
  final HeroSlide currentHeroSlide;

  ContentState copyWith({
    UserProfile? selectedProfile,
    Movie? selectedMovie,
    HeroSlide? currentHeroSlide,
    bool clearSelectedMovie = false,
  }) {
    return ContentState(
      selectedProfile: selectedProfile ?? this.selectedProfile,
      selectedMovie:
          clearSelectedMovie ? null : (selectedMovie ?? this.selectedMovie),
      currentHeroSlide: currentHeroSlide ?? this.currentHeroSlide,
    );
  }
}

class ContentNotifier extends StateNotifier<ContentState> {
  ContentNotifier()
      : super(
          ContentState(
            selectedProfile: profiles.first,
            selectedMovie: null,
            currentHeroSlide: fallbackHeroSlide,
          ),
        );

  void selectProfile(UserProfile profile) {
    state = state.copyWith(selectedProfile: profile);
  }

  void selectMovie(Movie movie) {
    state = state.copyWith(selectedMovie: movie);
  }

  void clearSelected() {
    state = state.copyWith(clearSelectedMovie: true);
  }

  void setHeroSlide(HeroSlide slide) {
    state = state.copyWith(currentHeroSlide: slide);
  }
}

final contentProvider = StateNotifierProvider<ContentNotifier, ContentState>(
  (ref) => ContentNotifier(),
);
