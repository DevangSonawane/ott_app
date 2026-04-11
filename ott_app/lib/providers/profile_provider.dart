import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content_data.dart';
import '../models/user_profile.dart';

class ProfileState {
  const ProfileState({
    required this.profiles,
    required this.isEditMode,
    required this.editingProfileId,
  });

  final List<UserProfile> profiles;
  final bool isEditMode;
  final String? editingProfileId;

  ProfileState copyWith({
    List<UserProfile>? profiles,
    bool? isEditMode,
    String? editingProfileId,
  }) {
    return ProfileState(
      profiles: profiles ?? this.profiles,
      isEditMode: isEditMode ?? this.isEditMode,
      editingProfileId: editingProfileId,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier()
      : super(ProfileState(
            profiles: List<UserProfile>.from(profiles),
            isEditMode: false,
            editingProfileId: null));

  void toggleEditMode() {
    state =
        state.copyWith(isEditMode: !state.isEditMode, editingProfileId: null);
  }

  void startEditing(String id) {
    state = state.copyWith(editingProfileId: id);
  }

  void stopEditing() {
    state = state.copyWith(editingProfileId: null);
  }

  void renameProfile({required String id, required String name}) {
    final updated = state.profiles
        .map((p) => p.id == id
            ? p.copyWith(name: name.trim().isEmpty ? p.name : name.trim())
            : p)
        .toList(growable: false);
    state = state.copyWith(profiles: updated);
  }

  void addProfile() {
    final newProfile = UserProfile(
      id: 'profile-${DateTime.now().millisecondsSinceEpoch}',
      name: 'New Profile',
      avatar: 'https://i.pravatar.cc/150?img=8',
      isKids: false,
    );
    state = state.copyWith(profiles: [...state.profiles, newProfile]);
  }

  void deleteProfile(String id) {
    state = state.copyWith(
        profiles:
            state.profiles.where((p) => p.id != id).toList(growable: false));
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
