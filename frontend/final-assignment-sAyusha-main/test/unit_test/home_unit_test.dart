import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/bidding/domain/use_case/bid_use_case.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_final_assignment/features/home/domain/use_case/home_use_case.dart';
import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:flutter_final_assignment/features/order_summary/domain/use_case/order_use_case.dart';
import 'package:flutter_final_assignment/features/profile/domain/use_case/profile_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeUseCase>(),
  MockSpec<ProfileUseCase>(),
  MockSpec<BidUseCase>(),
  MockSpec<OrderUseCase>(),
])
void main() {  
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late HomeUseCase mockHomeUsecase;
  late List<HomeEntity> homeEntity;

  setUpAll(() {
    mockHomeUsecase = MockHomeUseCase();
    homeEntity = [HomeEntity(
       image: "IMG-1690725538470.jpg",
        title: "Love & Hate 2",
        creator: "Juliana Yoshida",
        description: "This is the content of my art auction app.",
        startingBid: 1085.99,
        artType: "Recent",
        endingDate: DateTime.parse("2023-08-20 11:29"),
        upcomingDate: DateTime.parse("2023-08-20 11:29"),
        categories: "Painting"
    )];

    when(mockHomeUsecase.getAllArt())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        homeViewModelProvider.overrideWith(
          (ref) => HomeViewModel(mockHomeUsecase),
        ),
      ],
    );
  });

  test('check home initial state', ()async  {
    await container.read(homeViewModelProvider.notifier).getAllArt();
    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.arts, isEmpty);
  });

  test('check for the list of arts when calling getAllArt', () async {
    when(mockHomeUsecase.getAllArt())
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getAllArt();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.arts, isNotEmpty);
  });

  test('should not get arts when added', () async {
    when(mockHomeUsecase.getAllArt())
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));

    await container.read(homeViewModelProvider.notifier).getAllArt();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.error, isNull);
    // to fail the test, we have to right isNull instead of isNotNull
  });

   test('check for the list of arts by posted by user', () async {
    when(mockHomeUsecase.getUserArts())
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getUserArts();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.userArts, isNotEmpty);
  });

   test('should get list of arts by id', () async {
    when(mockHomeUsecase.getArtById("12"))
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getArtById("12");

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.artById.length, 1);
  });

  test('should get saved arts', () async {
    when(mockHomeUsecase.getSavedArts())
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getSavedArts();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.savedArts, isNotEmpty);
  });

  test('should get alert arts', () async {
    when(mockHomeUsecase.getAlertArts())
        .thenAnswer((_) => Future.value(Right(homeEntity)));

    await container.read(homeViewModelProvider.notifier).getAlertArts();

    final homeState = container.read(homeViewModelProvider);

    expect(homeState.isLoading, false);
    expect(homeState.alertArts, isNotEmpty);
  });

  tearDownAll(() {
    container.dispose();
  });
}