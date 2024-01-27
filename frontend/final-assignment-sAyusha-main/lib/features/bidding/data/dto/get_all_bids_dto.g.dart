// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_bids_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllBidsDTO _$GetAllBidsDTOFromJson(Map<String, dynamic> json) =>
    GetAllBidsDTO(
      data: (json['data'] as List<dynamic>)
          .map((e) => BidApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllBidsDTOToJson(GetAllBidsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
