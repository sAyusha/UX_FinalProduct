import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/profile_entity.dart';

part 'profile_api_model.g.dart';

final profileApiModelProvider = Provider<ProfileApiModel>(
  (ref) => ProfileApiModel.empty(),
);

@JsonSerializable()
class ProfileApiModel extends Equatable {
  @JsonKey(name: '_userId')
  final String? userId;

  final String? profileImage;
  final String fullname;
  final String username;
  final String email;
  final String? phone;
  final String? bio;
  // final List<String> savedPosts;

  const ProfileApiModel({
    required this.userId,
    this.profileImage,
    required this.fullname,
    required this.username,
    required this.email,
    this.phone,
    this.bio,
    // required this.savedPosts,
  });

  ProfileApiModel.empty()
      : userId = '',
        profileImage = '',
        fullname = '',
        username = '',
        email = '',
        phone = '',
        bio = '';
        // savedPosts = [];

  // Convert API object to entity
  ProfileEntity toEntity() => ProfileEntity(
        userId: userId ?? '',
        profileImage: profileImage,
        fullname: fullname,
        username: username,
        email: email,
        phone: phone,
        bio: bio,
        // savedPosts: savedPosts,
      );

  // Convert entity to API object
  ProfileApiModel fromEntity(ProfileEntity entity) => ProfileApiModel(
        userId: entity.userId ?? '',
        profileImage: entity.profileImage,
        fullname: entity.fullname,
        username: entity.username,
        email: entity.email,
        phone: entity.phone,
        bio: entity.bio,
        // savedPosts: entity.savedPosts,
      );

  // Convert API object list to entity list
  List<ProfileEntity> toEntityList(List<ProfileApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        userId,
        profileImage,
        fullname,
        username,
        phone,
        email,
        // savedPosts,
      ];

  //From Json
  factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);
}