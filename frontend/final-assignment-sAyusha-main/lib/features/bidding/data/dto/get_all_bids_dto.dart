import 'package:flutter_final_assignment/features/bidding/data/model/bid_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_bids_dto.g.dart';

@JsonSerializable()
class GetAllBidsDTO {
  final List<BidApiModel> data;

  GetAllBidsDTO({
    required this.data
  });

  // to json
  Map<String, dynamic> toJson() => _$GetAllBidsDTOToJson(this);

  // from json
  factory GetAllBidsDTO.fromJson(Map<String, dynamic> json) => _$GetAllBidsDTOFromJson(json);
  
}