// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_art_bid_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBidArtDTO _$GetBidArtDTOFromJson(Map<String, dynamic> json) => GetBidArtDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => BidApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetBidArtDTOToJson(GetBidArtDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
