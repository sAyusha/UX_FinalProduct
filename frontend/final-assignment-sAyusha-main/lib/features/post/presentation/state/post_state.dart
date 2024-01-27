import 'package:flutter_final_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';

class PostState {
  final bool isLoading;
  final List<PostEntity> arts;
  final List<UserEntity>? users;
  final String? error;
  final String? imageName;

  PostState({
    this.users,
    required this.isLoading,
    required this.arts,
    this.error,
    this.imageName,
  });

  factory PostState.initial() {
    return PostState(
      isLoading: false,
      arts: [],
      users: [],
      error: null,
      imageName: null,
    );
  }

  PostState copyWith({
    bool? isLoading,
    List<PostEntity>? arts,
    List<UserEntity>? users,
    String? error,
    String? imageName,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      arts: arts ?? this.arts,
      users: users ?? this.users,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
    );
  }
  
  //to string
  @override
  String toString() {
    return 'PostState(isLoading: $isLoading, arts: $arts, users: $users, error: $error, imageName: $imageName)';
  }
}


