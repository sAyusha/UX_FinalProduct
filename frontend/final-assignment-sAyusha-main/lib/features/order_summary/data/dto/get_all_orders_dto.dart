import 'package:json_annotation/json_annotation.dart';

import '../model/order_api_model.dart';

part 'get_all_orders_dto.g.dart';

@JsonSerializable()
class GetAllOrderDTO{
  final List<OrderApiModel> data;

  GetAllOrderDTO({
    required this.data
  });

  // to json
  Map<String, dynamic> toJson() => _$GetAllOrderDTOToJson(this);

  // from json
  factory GetAllOrderDTO.fromJson(Map<String, dynamic> json) => _$GetAllOrderDTOFromJson(json);
  
}