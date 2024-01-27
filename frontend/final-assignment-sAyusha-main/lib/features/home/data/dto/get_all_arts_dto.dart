import 'package:flutter_final_assignment/features/home/data/model/home_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_arts_dto.g.dart';

@JsonSerializable()
class GetAllArtDTO {
  final List<HomeApiModel> data;

  GetAllArtDTO({
    required this.data
  });

  // to json
  Map<String, dynamic> toJson() => _$GetAllArtDTOToJson(this);

  // from json
  factory GetAllArtDTO.fromJson(Map<String, dynamic> json) => _$GetAllArtDTOFromJson(json);
  
}