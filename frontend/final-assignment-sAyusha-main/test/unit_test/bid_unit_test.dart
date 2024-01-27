import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/bidding/domain/entity/bidding_entity.dart';
import 'package:flutter_final_assignment/features/bidding/domain/use_case/bid_use_case.dart';
import 'package:flutter_final_assignment/features/bidding/presentation/viewmodel/bid_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'home_unit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late BidUseCase mockBidUseCase;
  late List<BidEntity> bidEntity;

  setUpAll(() async {
    mockBidUseCase = MockBidUseCase();
    bidEntity = [
      const BidEntity(bidAmount: 1000.00)
    ];
    when(mockBidUseCase.getAllBids())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        bidViewModelProvider.overrideWith(
          (ref) => BidViewModel(mockBidUseCase),
        )
      ],
    );
  });

  test('check bid initial state', () async {
    await container.read(bidViewModelProvider.notifier).getAllBids();

    final bidState = container.read(bidViewModelProvider);
    expect(bidState.isLoading, false);
    expect(bidState.bids, isEmpty);
  });

  test('should get bids placed on art', () async {
    when(mockBidUseCase.getAllBids())
        .thenAnswer((_) => Future.value(Right(bidEntity)));

    await container.read(bidViewModelProvider.notifier).getAllBids();

    final bidState = container.read(bidViewModelProvider);

    expect(bidState.isLoading, false);
    expect(bidState.bids.length, 1);
  });

  tearDownAll(() {
    container.dispose();
  });

  test('should not get bid on a particular art', () async {
    when(mockBidUseCase.getAllBids())
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));

    await container.read(bidViewModelProvider.notifier).getAllBids();

    final bidState = container.read(bidViewModelProvider);

    expect(bidState.isLoading, false);
    expect(bidState.error, isNotNull);

  });

    test('should get bid by id placed on art', () async {
    when(mockBidUseCase.getBid("12"))
        .thenAnswer((_) => Future.value(const Right([])));

    await container.read(bidViewModelProvider.notifier).getBid("12");

    final bidState = container.read(bidViewModelProvider);

    expect(bidState.isLoading, false);
    expect(bidState.bids.length, 0);
  });

  tearDownAll(() {
    container.dispose();
  });

  tearDownAll(() {
    container.dispose();
  });
}