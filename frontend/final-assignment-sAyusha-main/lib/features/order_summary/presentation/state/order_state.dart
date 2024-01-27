import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';

import '../../../auth/domain/entity/user_entity.dart';
import '../../domain/entity/order_entity.dart';

class OrderState {
  final bool isLoading;
  final List<OrderEntity> orders;
  final List<OrderEntity> yourOrders;
  final List<OrderEntity> orderById;
  final List<UserEntity> userProfile;
  final List<HomeEntity> arts;
  final List<HomeEntity> artById;
  final List<HomeEntity> userArts;
  final String? error;

  OrderState({
    required this.isLoading,
    required this.orders,
    required this.yourOrders,
    required this.orderById,
    required this.userProfile,
    required this.arts,
    required this.artById,
    required this.userArts,
    this.error,
  });

  factory OrderState.initial() => OrderState(
        isLoading: false,
        orders: [],
        yourOrders: [],
        orderById: [],
        userProfile: [],
        arts: [],
        artById: [],
        userArts: [],
      );

  OrderState copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    List<OrderEntity>? yourOrders,
    List<OrderEntity>? orderById,
    List<UserEntity>? userProfile,
    List<HomeEntity>? arts,
    List<HomeEntity>? artById,
    List<HomeEntity>? userArts,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      yourOrders: yourOrders ?? this.yourOrders,
      orderById: orderById ?? this.orderById,
      userProfile: userProfile ?? this.userProfile,
      arts: arts ?? this.arts,
      artById: artById ?? this.artById,
      userArts: userArts ?? this.userArts,
      error: error ?? this.error,
    );
  }
}
