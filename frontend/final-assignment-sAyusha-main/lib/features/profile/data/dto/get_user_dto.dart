import 'package:json_annotation/json_annotation.dart';

import '../model/profile_api_model.dart';

part 'get_user_dto.g.dart';

@JsonSerializable()
class GetUserDTO {
  final List<ProfileApiModel> data;

  GetUserDTO({
    required this.data,
  });

  factory GetUserDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDTOToJson(this);
}