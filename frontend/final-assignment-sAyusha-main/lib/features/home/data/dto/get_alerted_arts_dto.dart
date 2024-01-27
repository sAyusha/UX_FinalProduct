import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';

part 'get_alerted_arts_dto.g.dart';

@JsonSerializable()
class GetAlertArtsDTO {
  final List<HomeApiModel> data;

  GetAlertArtsDTO({
    required this.data,
  });

  factory GetAlertArtsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAlertArtsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAlertArtsDTOToJson(this);
}