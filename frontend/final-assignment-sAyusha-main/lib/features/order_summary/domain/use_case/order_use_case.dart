import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/repository/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/order_entity.dart';

// dependency injection using riverpod
final orderUseCaseProvider = Provider.autoDispose<OrderUseCase>(
  (ref) => OrderUseCase(
    orderRepository: ref.watch(orderRepositoryProvider),
  ),
);

class OrderUseCase{
  final IOrderRepository orderRepository;

  OrderUseCase({
    required this.orderRepository,
  });

  Future<Either<Failure,bool>> addOrder(OrderEntity order, String artId) async{
    return await orderRepository.addOrder(order, artId);
  }


  // Future<Either<Failure,List<OrderEntity>>> getAllOrders(String artId) async{
  //   return await orderRepository.getAllOrders(artId);
  // }

  Future<Either<Failure, List<OrderEntity>>> getYourOrder() async{
    return await orderRepository.getYourOrder();
  }

  Future<Either<Failure, List<OrderEntity>>> getOrderById( String orderId) async{
    return await orderRepository.getOrderById( orderId);
  }

  Future<Either<Failure, bool>> updateOrderToPaid( String orderId) async{
    return await orderRepository.updateOrderToPaid( orderId);
  }
}