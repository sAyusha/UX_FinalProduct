import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';

part 'get_saved_arts_dto.g.dart';

@JsonSerializable()
class GetSavedArtsDTO {
  final List<HomeApiModel> data;

  GetSavedArtsDTO({
    required this.data,
  });

  factory GetSavedArtsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetSavedArtsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetSavedArtsDTOToJson(this);
}