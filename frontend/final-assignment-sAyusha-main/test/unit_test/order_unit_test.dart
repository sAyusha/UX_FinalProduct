import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/entity/order_entity.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/use_case/order_use_case.dart';
import 'package:flutter_final_assignment/features/order_summary/presentation/viewmodel/order_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'home_unit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late OrderUseCase mockOrderUseCase;
  late List<OrderEntity> orderEntity;

  setUpAll(() async {
    mockOrderUseCase = MockOrderUseCase();
    orderEntity = [
      const OrderEntity(
        orderItems: [
          OrderItem(
            image: "abc.jpg",
            title: "abc",
            description: "hejiwdncwc"
          )
        ], 
        shippingAddress: ShippingAddress(
          fullname: "Test User", 
          address: "Kalanki", 
          postalCode: "44600", 
          city: "KTM", 
          request: "no req"
        ), 
        paymentMethod: "khaliti", 
        bidAmount: 180, 
        shippingPrice: 20, 
        totalAmount: 200
      ),
    ];
    when(mockOrderUseCase.getYourOrder())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        orderViewModelProvider.overrideWith(
          (ref) => OrderViewModel(mockOrderUseCase),
        )
      ],
    );
  });

  test('check order initial state', () async {
    await container.read(orderViewModelProvider.notifier).getYourOrder();

    final orderState = container.read(orderViewModelProvider);
    expect(orderState.isLoading, false);
    expect(orderState.orders, isEmpty);
  });
  test('should get art order', () async {
    when(mockOrderUseCase.getYourOrder())
        .thenAnswer((_) => Future.value(Right(orderEntity)));

    await container.read(orderViewModelProvider.notifier).getYourOrder();

    final orderState = container.read(orderViewModelProvider);

    expect(orderState.isLoading, false);
    expect(orderState.error, isNull);
  });

  tearDownAll(() {
    container.dispose();
  });

  test('should not get art order', () async {
    when(mockOrderUseCase.getYourOrder())
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));

    await container.read(orderViewModelProvider.notifier).getYourOrder();

    final orderState = container.read(orderViewModelProvider);

    expect(orderState.isLoading, false);
    expect(orderState.error, isNotNull);

  });

    test('should get art order by id', () async {
    when(mockOrderUseCase.getOrderById("12"))
        .thenAnswer((_) => Future.value(Right(orderEntity)));

    await container.read(orderViewModelProvider.notifier).getOrderById("12");

    final orderState = container.read(orderViewModelProvider);

    expect(orderState.isLoading, false);
    expect(orderState.orderById.length, 1);
  });

  tearDownAll(() {
    container.dispose();
  });

  tearDownAll(() {
    container.dispose();
  });
}