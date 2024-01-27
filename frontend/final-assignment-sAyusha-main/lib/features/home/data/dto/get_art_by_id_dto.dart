import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';

part 'get_art_by_id_dto.g.dart';

@JsonSerializable()
class GetArtByIdDTO {
  final List<HomeApiModel> data;

  GetArtByIdDTO({
    required this.data,
  });

  factory GetArtByIdDTO.fromJson(Map<String, dynamic> json) =>
      _$GetArtByIdDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetArtByIdDTOToJson(this);
}