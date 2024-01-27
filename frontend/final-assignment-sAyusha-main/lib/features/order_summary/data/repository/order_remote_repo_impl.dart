import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/entity/order_entity.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/repository/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/order_remote_source.dart';

// dependency injection using riverpod
final orderRemoteRepoProvider = Provider.autoDispose<IOrderRepository>(
  (ref) => OrderRemoteRepositoryImpl(
    orderRemoteDataSource: ref.read(orderRemoteDataSourceProvider),
  ),
);

class OrderRemoteRepositoryImpl implements IOrderRepository{
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRemoteRepositoryImpl({
    required this.orderRemoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> addOrder(OrderEntity order, String artId) {
    return orderRemoteDataSource.addOrder(order, artId);
  }
  

  // @override
  // Future<Either<Failure, List<OrderEntity>>> getAllOrders(String artId) {
  //   return orderRemoteDataSource.getAllOrders(artId);
  // }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderById(String orderId) {
    return orderRemoteDataSource.getOrderById(orderId);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getYourOrder() {
    return orderRemoteDataSource.getYourOrder();
  }

  @override
  Future<Either<Failure, bool>> updateOrderToPaid( String orderId) {
    return orderRemoteDataSource.updateOrderToPaid( orderId);  
  }
}