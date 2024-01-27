import 'package:json_annotation/json_annotation.dart';

import '../model/order_api_model.dart';

part 'get_order_by_id_dto.g.dart';

@JsonSerializable()
class GetOrderByIdDTO{
  final List<OrderApiModel> data;

  GetOrderByIdDTO({
    required this.data
  });

  // to json
  Map<String, dynamic> toJson() => _$GetOrderByIdDTOToJson(this);

  // from json
  factory GetOrderByIdDTO.fromJson(Map<String, dynamic> json) => _$GetOrderByIdDTOFromJson(json);
}