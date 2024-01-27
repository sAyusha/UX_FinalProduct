import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/core/network/remote/http_service.dart';
import 'package:flutter_final_assignment/features/home/data/model/home_api_model.dart';
// import 'package:flutter_final_assignment/features/order_summary/data/dto/get_all_orders_dto.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/entity/order_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/shared_preferences/user_shared_prefs.dart';
// import '../dto/get_order_by_id_dto.dart';
// import '../dto/get_users_order_dto.dart';
import '../dto/get_order_by_id_dto.dart';
import '../dto/get_users_order_dto.dart';
import '../model/order_api_model.dart';

// dependency injection using riverpod
final orderRemoteDataSourceProvider = Provider.autoDispose(
  (ref) => OrderRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    homeApiModel: ref.read(homeApiModelProvider),
    orderApiModel: ref.read(orderApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class OrderRemoteDataSource {
  final Dio dio;
  final HomeApiModel homeApiModel;
  final OrderApiModel orderApiModel;
  final UserSharedPrefs userSharedPrefs;

  OrderRemoteDataSource({
    required this.dio,
    required this.homeApiModel,
    required this.orderApiModel,
    required this.userSharedPrefs,
  });

  // place an order
  Future<Either<Failure, bool>> addOrder(
      OrderEntity order, String artId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );
      var response = await dio.post(
        ApiEndpoints.addOrder(artId),
        data: orderApiModel.fromEntity(order).toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(Failure(
          error: response.data['message'],
          statusCode: response.statusCode.toString(),
        ));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(Failure(
          error: e.response!.data['message'],
          statusCode: e.response!.statusCode.toString(),
        ));
      } else {
        return Left(Failure(error: e.message ?? e.toString()));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  // // get all orders
  // Future<Either<Failure, List<OrderEntity>>> getAllOrders(String artId) async {
  //   try {
  //     // get token
  //     String? token;
  //     await userSharedPrefs
  //         .getUserToken()
  //         .then((value) => value.fold((l) => null, (r) => token = r!));
  //     var response = await dio.get(ApiEndpoints.getAllOrders(artId),
  //         options: Options(
  //           headers: {
  //             'Authorization': 'Bearer $token',
  //           },
  //         ));
  //     if (response.statusCode == 200) {
  //       // OR
  //       // 2nd way
  //       GetAllOrderDTO getOrderDTO = GetAllOrderDTO.fromJson(response.data);
  //       return Right(orderApiModel.toEntityList(getOrderDTO.data));
  //     } else {
  //       return Left(
  //         Failure(
  //           error: response.statusMessage.toString(),
  //           statusCode: response.statusCode.toString(),
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     return Left(
  //       Failure(
  //         error: e.error.toString(),
  //       ),
  //     );
  //   }
  // }

  // get user order
  Future<Either<Failure, List<OrderEntity>>> getYourOrder() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getYourOrder,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetUsersOrderDTO userOrderDTO =
            GetUsersOrderDTO.fromJson(response.data);
        return Right(orderApiModel.toEntityList(userOrderDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  // get order by id
  Future<Either<Failure, List<OrderEntity>>> getOrderById(
      String orderId) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getOrderById(orderId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetOrderByIdDTO orderDTO = GetOrderByIdDTO.fromJson(response.data);
        return Right(orderApiModel.toEntityList(orderDTO.data));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  // update order to paid
  Future<Either<Failure, bool>> updateOrderToPaid(String orderId) async {
    try {
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
        (l) => token = null,
        (r) => token = r,
      );

      var response = await dio.put(
        ApiEndpoints.updateOrderToPaid(orderId),
        // data: {
        //   'id': paymentResult.id,
        //   'status': paymentResult.status,
        //   'update_time': paymentResult.updateTime,
        //   'email_address': paymentResult.emailAddress,
        // },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: 'Failed to update art to paid. Please try again.',
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }
}
