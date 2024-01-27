import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/use_case/profile_use_case.dart';
import '../state/profile_state.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
  (ref) => ProfileViewModel(
    ref.read(profileUseCaseProvider),
  ),
);

class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileViewModel(this.profileUseCase) : super(ProfileState.initial()) {
    getUserProfile();
  }

  // void resetState() {
  //   state = ProfileState.initial();
  // }

  getUserProfile() async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.getUserProfile();
    state = state.copyWith(userData: []);
    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, userData: r, error: null),
    );
  }

  uploadProfilePicture(File? file) async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.uploadProfilePicture(file!);
    data.fold(
      (l) {
        state = state.copyWith(isLoading: false, error: l.error);
      },
      (imageName) {
        state =
            state.copyWith(isLoading: false, error: null, imageName: imageName);
      },
    );
  }

  editProfile(ProfileEntity profile) async {
    state = state.copyWith(isLoading: true);
    var data = await profileUseCase.editProfile(profile);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }
}