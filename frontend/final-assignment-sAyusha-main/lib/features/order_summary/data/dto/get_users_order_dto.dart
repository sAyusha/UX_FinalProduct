import 'package:json_annotation/json_annotation.dart';

import '../model/order_api_model.dart';
part 'get_users_order_dto.g.dart';

@JsonSerializable()
class GetUsersOrderDTO{
  final List<OrderApiModel> data;

  GetUsersOrderDTO({
    required this.data
  });

  // to json
  Map<String, dynamic> toJson() => _$GetUsersOrderDTOToJson(this);

  // from json
  factory GetUsersOrderDTO.fromJson(Map<String, dynamic> json) => _$GetUsersOrderDTOFromJson(json);
}