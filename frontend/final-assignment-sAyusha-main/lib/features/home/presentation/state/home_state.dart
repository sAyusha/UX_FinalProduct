import '../../../auth/domain/entity/user_entity.dart';
import '../../domain/entity/home_entity.dart';

class HomeState {
  final bool isLoading;
  final List<HomeEntity> users;
  final List<HomeEntity> arts;
  final List<UserEntity> userProfile;
  final List<HomeEntity> savedArts;
  final List<HomeEntity> alertArts;
  final List<HomeEntity> userArts;
  final List<HomeEntity> artById;
  final String? error;

  HomeState({
    required this.isLoading,
    required this.users,
    required this.arts,
    required this.userProfile,
    required this.savedArts,
    required this.alertArts,
    required this.userArts,
    required this.artById,
    this.error,
  });

  factory HomeState.initial() => HomeState(
        isLoading: false,
        users: [],
        arts: [],
        userProfile: [],
        savedArts: [],
        alertArts: [],
        userArts: [],
        artById: [],
      );

  HomeState copyWith({
    bool? isLoading,
    List<HomeEntity>? users,
    List<HomeEntity>? arts,
    List<UserEntity>? userProfile,
    List<HomeEntity>? savedArts,
    List<HomeEntity>? alertArts,
    List<HomeEntity>? userArts,
    List<HomeEntity>? artById,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      arts: arts ?? this.arts,
      userProfile: userProfile ?? this.userProfile,
      savedArts: savedArts ?? this.savedArts,
      alertArts: alertArts ?? this.alertArts,
      userArts: userArts ?? this.userArts,
      artById: artById ?? this.artById,
      error: error ?? this.error,
    );
  }
}
