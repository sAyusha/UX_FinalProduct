// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiModel _$PostApiModelFromJson(Map<String, dynamic> json) => PostApiModel(
      artId: json['_id'] as String?,
      image: json['image'] as String,
      title: json['title'] as String,
      creator: json['creator'] as String,
      description: json['description'] as String,
      startingBid: json['startingBid'] as num,
      endingDate: DateTime.parse(json['endingDate'] as String),
      artType: json['artType'] as String,
      upcomingDate: DateTime.parse(json['upcomingDate'] as String),
      categories: json['categories'] as String,
    );

Map<String, dynamic> _$PostApiModelToJson(PostApiModel instance) =>
    <String, dynamic>{
      '_id': instance.artId,
      'image': instance.image,
      'title': instance.title,
      'creator': instance.creator,
      'description': instance.description,
      'startingBid': instance.startingBid,
      'endingDate': instance.endingDate.toIso8601String(),
      'artType': instance.artType,
      'upcomingDate': instance.upcomingDate.toIso8601String(),
      'categories': instance.categories,
    };
