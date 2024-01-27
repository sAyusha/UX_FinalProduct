// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_art_by_id_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetArtByIdDTO _$GetArtByIdDTOFromJson(Map<String, dynamic> json) =>
    GetArtByIdDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => HomeApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetArtByIdDTOToJson(GetArtByIdDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
