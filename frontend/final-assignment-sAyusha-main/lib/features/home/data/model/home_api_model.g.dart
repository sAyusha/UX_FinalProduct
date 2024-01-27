// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeApiModel _$HomeApiModelFromJson(Map<String, dynamic> json) => HomeApiModel(
      artId: json['_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      creator: json['creator'] as String,
      image: json['image'] as String?,
      profileImage: json['profileImage'] as String?,
      endingDate: DateTime.parse(json['endingDate'] as String),
      startingBid: json['startingBid'] as num,
      artType: json['artType'] as String,
      upcomingDate: DateTime.parse(json['upcomingDate'] as String),
      categories: json['categories'] as String,
      isSaved: json['isSaved'] as bool?,
      isAlert: json['isAlert'] as bool?,
      isUserLoggedIn: json['isUserLoggedIn'] as bool?,
      artExpired: json['artExpired'] as bool?,
    );

Map<String, dynamic> _$HomeApiModelToJson(HomeApiModel instance) =>
    <String, dynamic>{
      '_id': instance.artId,
      'title': instance.title,
      'description': instance.description,
      'creator': instance.creator,
      'image': instance.image,
      'profileImage': instance.profileImage,
      'endingDate': instance.endingDate.toIso8601String(),
      'startingBid': instance.startingBid,
      'artType': instance.artType,
      'upcomingDate': instance.upcomingDate.toIso8601String(),
      'categories': instance.categories,
      'isSaved': instance.isSaved,
      'isAlert': instance.isAlert,
      'isUserLoggedIn': instance.isUserLoggedIn,
      'artExpired': instance.artExpired,
    };
