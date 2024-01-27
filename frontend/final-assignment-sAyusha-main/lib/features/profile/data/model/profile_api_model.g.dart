// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileApiModel _$ProfileApiModelFromJson(Map<String, dynamic> json) =>
    ProfileApiModel(
      userId: json['_userId'] as String?,
      profileImage: json['profileImage'] as String?,
      fullname: json['fullname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) =>
    <String, dynamic>{
      '_userId': instance.userId,
      'profileImage': instance.profileImage,
      'fullname': instance.fullname,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'bio': instance.bio,
    };
