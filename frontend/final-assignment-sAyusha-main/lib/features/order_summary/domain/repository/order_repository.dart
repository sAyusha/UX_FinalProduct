import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../data/repository/order_remote_repo_impl.dart';
import '../entity/order_entity.dart';

// dependency injection using riverpod
final orderRepositoryProvider = Provider.autoDispose<IOrderRepository>(
  (ref) {
    return ref.watch(orderRemoteRepoProvider);
  } 
);

abstract class IOrderRepository{
  // Future<Either<Failure, List<OrderEntity>>> getAllOrders(String artId);
  Future<Either<Failure, bool>> addOrder(OrderEntity order, String artId);
  Future<Either<Failure, List<OrderEntity>>> getYourOrder();
  Future<Either<Failure, List<OrderEntity>>> getOrderById( String orderId);
  Future<Either<Failure, bool>> updateOrderToPaid( String orderId);
}