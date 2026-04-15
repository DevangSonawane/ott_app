import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie.dart';

class PlayerState {
  const PlayerState({required this.current});

  final Movie? current;

  bool get isPlaying => current != null;

  PlayerState copyWith({Movie? current}) {
    return PlayerState(current: current);
  }
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier() : super(const PlayerState(current: null));

  void play(Movie movie) {
    state = state.copyWith(current: movie);
  }

  void stop() {
    state = state.copyWith(current: null);
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>(
  (ref) => PlayerNotifier(),
);
