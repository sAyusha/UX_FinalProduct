// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_saved_arts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSavedArtsDTO _$GetSavedArtsDTOFromJson(Map<String, dynamic> json) =>
    GetSavedArtsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetSavedArtsDTOToJson(GetSavedArtsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
