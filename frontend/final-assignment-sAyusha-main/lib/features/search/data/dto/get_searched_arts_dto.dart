import 'package:json_annotation/json_annotation.dart';

import '../../../home/data/model/home_api_model.dart';

part 'get_searched_arts_dto.g.dart';

@JsonSerializable()
class GetSearchArtsDTO {
  final List<HomeApiModel> data;

  GetSearchArtsDTO({
    required this.data,
  });

  factory GetSearchArtsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetSearchArtsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetSearchArtsDTOToJson(this);
}