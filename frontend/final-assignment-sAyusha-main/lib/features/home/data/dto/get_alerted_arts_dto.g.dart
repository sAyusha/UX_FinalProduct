// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_alerted_arts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAlertArtsDTO _$GetAlertArtsDTOFromJson(Map<String, dynamic> json) =>
    GetAlertArtsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAlertArtsDTOToJson(GetAlertArtsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
