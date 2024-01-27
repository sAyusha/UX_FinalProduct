import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/config/router/app_route.dart';
import 'package:flutter_final_assignment/config/constants/size_config.dart';
import 'package:flutter_final_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_final_assignment/features/auth/domain/use_case/auth_usecase.dart';
import 'package:flutter_final_assignment/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test/unit_test/auth_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<SizeConfig>(),
  MockSpec<BuildContext>(),
])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;
  late UserEntity userEntity;

  setUpAll(
    () async {
      mockAuthUsecase = MockAuthUseCase();

      userEntity = const UserEntity(
        fullname: 'Jasmine Osti',
        username: 'jasuux',
        email: 'jas123@gmail.com',
        phone: '1234567890',
        password: 'jasuux123',
      );

      // Set the values for screenWidth and screenHeight
      SizeConfig.screenWidth = 360; // Set the desired width value
      SizeConfig.screenHeight = 640; // Set the desired height value
    },
  );

  testWidgets('register view ...', (tester) async {
    when(mockAuthUsecase.registerUser(userEntity))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(mockAuthUsecase),
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoute.registerRoute,
          routes: AppRoute.getApplicationRoute(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter first textform field i.e. fullname
    await tester.enterText(find.byType(TextFormField).at(0), 'Jasmine Osti');
    // Enter second textform field i.e. username
    await tester.enterText(find.byType(TextFormField).at(1), 'jasuux');
    // Enter email
    await tester.enterText(
        find.byType(TextFormField).at(2), 'jas123@gmail.com');
    // Enter phone number
    await tester.enterText(find.byType(TextFormField).at(3), '1234567890');
    // Enter password
    await tester.enterText(find.byType(TextFormField).at(4), 'jasuux123');

    // Using this because the menu items are not visible
    await tester.pumpAndSettle();

    //=========================== Find the register button===========================
    final registerButtonFinder = find.widgetWithText(ElevatedButton, 'NEXT');

    // widget you want to find
    await tester.dragUntilVisible(
      registerButtonFinder,
      find.byType(SingleChildScrollView), 
        const Offset(196.4, 556.0) // offset of the widget you want to find
    );
    await tester.tap(
      registerButtonFinder,
    );
    await tester.pump();

    expect(find.widgetWithText(SnackBar, 'Registered Successfully'),
        findsOneWidget);
  });
}
