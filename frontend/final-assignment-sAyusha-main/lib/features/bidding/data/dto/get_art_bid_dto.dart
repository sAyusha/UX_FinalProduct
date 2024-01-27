import 'package:flutter_final_assignment/features/bidding/data/model/bid_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_art_bid_dto.g.dart';

@JsonSerializable()
class GetBidArtDTO {
  final List<BidApiModel> data;

  GetBidArtDTO({
    required this.data,
  });

  // to json
  Map<String, dynamic> toJson() => _$GetBidArtDTOToJson(this);

  // from json
  factory GetBidArtDTO.fromJson(Map<String, dynamic> json) =>
      _$GetBidArtDTOFromJson(json);
}
