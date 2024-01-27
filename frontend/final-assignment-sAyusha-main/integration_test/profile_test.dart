import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_final_assignment/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_final_assignment/features/profile/domain/use_case/profile_use_case.dart';
import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_test/home_unit_test.mocks.dart';
import '../test_data/profile_entity_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProfileUseCase mockProfileUseCase;
  late List<ProfileEntity> profileEntity;

  setUpAll(() async {
    mockProfileUseCase = MockProfileUseCase();
    profileEntity = await getProfileTest();
    SizeConfig.screenWidth = 360; // Set the desired width value
    SizeConfig.screenHeight = 640; // Set the desired height value
  });

  testWidgets('Profile View', (tester) async {
    when(mockProfileUseCase.getUserProfile())
        .thenAnswer((_) async => Right(profileEntity));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileViewModelProvider
              .overrideWith((ref) => ProfileViewModel(mockProfileUseCase)),
        ],
        child: MaterialApp(
          routes: AppRoute.getApplicationRoute(),
          initialRoute: AppRoute.profileRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Edit Profile'), findsOneWidget);
  });
}
