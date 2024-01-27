// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_arts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserArtsDTO _$GetUserArtsDTOFromJson(Map<String, dynamic> json) =>
    GetUserArtsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUserArtsDTOToJson(GetUserArtsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
