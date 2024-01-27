import 'package:dartz/dartz.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_final_assignment/features/profile/domain/use_case/profile_use_case.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_data/profile_entity_test.dart';
import 'home_unit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late ProfileUseCase mockProfileUseCase;
  late List<ProfileEntity> profileEntity;

  setUpAll(() async {
    mockProfileUseCase = MockProfileUseCase();
    profileEntity = await getProfileTest();
    when(mockProfileUseCase.getUserProfile())
        .thenAnswer((_) async => const Right([]));

    container = ProviderContainer(
      overrides: [
        profileViewModelProvider.overrideWith(
          (ref) => ProfileViewModel(mockProfileUseCase),
        )
      ],
    );
  });

  test('check profile initial state', () async {
    await container.read(profileViewModelProvider.notifier).getUserProfile();

    final profileState = container.read(profileViewModelProvider);
    expect(profileState.isLoading, false);
    expect(profileState.userData, isEmpty);
  });

  test('should get profile', () async {
    when(mockProfileUseCase.getUserProfile())
        .thenAnswer((_) => Future.value(Right(profileEntity)));

    await container.read(profileViewModelProvider.notifier).getUserProfile();

    final profileState = container.read(profileViewModelProvider);

    expect(profileState.isLoading, false);
    expect(profileState.userData.length, 1);
  });

  tearDownAll(() {
    container.dispose();
  });

  test('should not get profile', () async {
    when(mockProfileUseCase.getUserProfile())
        .thenAnswer((_) => Future.value(Left(Failure(error: "Invalid"))));

    await container.read(profileViewModelProvider.notifier).getUserProfile();

    final profileState = container.read(profileViewModelProvider);

    expect(profileState.isLoading, false);
    expect(profileState.error, isNull);
    //to fail the test keep isNull instead of isNotNull
  });

  tearDownAll(() {
    container.dispose();
  });
}