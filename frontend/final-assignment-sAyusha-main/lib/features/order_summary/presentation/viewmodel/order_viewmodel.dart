import 'package:flutter_final_assignment/features/order_summary/domain/entity/order_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/use_case/order_use_case.dart';
import '../state/order_state.dart';

// dependency injection using riverpod
final orderViewModelProvider =
    StateNotifierProvider.autoDispose<OrderViewModel, OrderState>((ref) {
  return OrderViewModel(
    ref.read(orderUseCaseProvider),
  );
});

class OrderViewModel extends StateNotifier<OrderState> {
  final OrderUseCase orderUseCase;

  OrderViewModel(
    this.orderUseCase,
  ) : super(OrderState.initial()) {
    // get('artId');
    // getYourOrder('artId');
    // getOrderById('artId','orderId');
  }

  Future<void> addOrder(OrderEntity order, String artId) async {
    state = state.copyWith(isLoading: true);
    final data = await orderUseCase.addOrder(order, artId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) {
        state = state.copyWith(isLoading: false, error: null);
      },
    );
  }

//   getAllOrders(String artId) async {
//     state = state.copyWith(isLoading: true);
//     var data = await orderUseCase.getAllOrders(artId);

//     data.fold(
//       (l) => state = state.copyWith(isLoading: false, error: l.error),
//       (r) => state = state.copyWith(isLoading: false, orders: r, error: null),
//     );
//   }

  getYourOrder() async {
    state = state.copyWith(isLoading: true);
    var data = await orderUseCase.getYourOrder();

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) =>
          state = state.copyWith(isLoading: false, yourOrders: r, error: null),
    );
  }

  getOrderById(String orderId) async {
    state = state.copyWith(isLoading: true);
    var data = await orderUseCase.getOrderById(orderId);
    state = state.copyWith(orderById: []);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) =>
          state = state.copyWith(isLoading: false, orderById: r, error: null),
    );
  }

  Future<void> updateOrderToPaid(String orderId) async {
    state = state.copyWith(isLoading: true);
    final data = await orderUseCase.updateOrderToPaid(orderId);

    data.fold(
      (l) => state = state.copyWith(isLoading: false, error: l.error),
      (r) => state = state.copyWith(isLoading: false, error: null),
    );
  }
}
