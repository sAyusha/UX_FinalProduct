import '../../domain/entity/profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final String? error;
  final String? imageName;
  final List<ProfileEntity> userData;

  ProfileState({
    required this.isLoading,
    this.error,
    this.imageName,
    required this.userData,
  });

  factory ProfileState.initial() => ProfileState(
        isLoading: false,
        imageName: null,
        error: null,
        userData: [],
      );

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    String? imageName,
    List<ProfileEntity>? userData,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
      userData: userData ?? this.userData,
    );
  }

  @override
  String toString() {
    return 'ProfileState{isLoading: $isLoading, error: $error, imageName: $imageName, userData: $userData}';
  }
}