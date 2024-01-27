import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';


part 'get_user_arts_dto.g.dart';

@JsonSerializable()
class GetUserArtsDTO {
  final List<HomeApiModel> data;

  GetUserArtsDTO({
    required this.data,
  });

  factory GetUserArtsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserArtsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserArtsDTOToJson(this);
}