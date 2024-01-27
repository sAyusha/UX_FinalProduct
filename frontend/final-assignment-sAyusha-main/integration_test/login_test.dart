// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_final_assignment/config/router/app_route.dart';
// import 'package:flutter_final_assignment/config/constants/size_config.dart';
// import 'package:flutter_final_assignment/features/auth/domain/use_case/auth_usecase.dart';
// import 'package:flutter_final_assignment/features/auth/presentation/viewmodel/auth_view_model.dart';
// import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
// import 'package:flutter_final_assignment/features/home/domain/use_case/home_use_case.dart';
// import 'package:flutter_final_assignment/features/home/presentation/viewmodel/home_viewmodel.dart';
// import 'package:flutter_final_assignment/features/profile/domain/entity/profile_entity.dart';
// import 'package:flutter_final_assignment/features/profile/domain/use_case/profile_use_case.dart';
// import 'package:flutter_final_assignment/features/profile/presentation/viewmodel/profile_viewmodel.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// // import '../build/app/intermediates/assets/debug/mergeDebugAssets/flutter_assets/test_data/profile_entity_test.dart';
// import '../test/unit_test/auth_unit_test.mocks.dart';
// import '../test/unit_test/home_unit_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<AuthUseCase>(),
//   MockSpec<SizeConfig>(),
//   MockSpec<BuildContext>(),
// ])
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late AuthUseCase mockAuthUseCase;
//   late HomeUseCase mockHomeUseCase;
//   late ProfileUseCase mockProfileUseCase;
//   late List<HomeEntity> homeEntity;
//   late List<ProfileEntity> profileEntity;
//   late List<HomeEntity> userArts;
//   // late SizeConfig mockSizeConfig;
//   // late BuildContext context;
//   late bool isLogin;

//   setUpAll(() async {
//     mockAuthUseCase = MockAuthUseCase();
//     mockHomeUseCase = MockHomeUseCase();
//     mockProfileUseCase = MockProfileUseCase();
//     homeEntity = [
//       HomeEntity(
//           image: "IMG-1690725538470.jpg",
//           title: "Love & Hate 2",
//           creator: "Juliana Yoshida",
//           description: "This is the content of my art auction app.",
//           startingBid: 1085.99,
//           artType: "Recent",
//           endingDate: DateTime.parse("2023-08-20 11:29"),
//           upcomingDate: DateTime.parse("2023-08-20 11:29"),
//           categories: "Painting")
//     ];
//     profileEntity = await getProfileTest();
//     // mockSizeConfig = MockSizeConfig();
//     // context = MockBuildContext();
//     isLogin = true;

//     // Set the values for screenWidth and screenHeight
//     SizeConfig.screenWidth = 360; // Set the desired width value
//     SizeConfig.screenHeight = 900; // Set the desired height value
//   });

//   testWidgets(
//       'login test with username and password and open a page inisde it ',
//       (WidgetTester tester) async {
//     // Stub the describeWidget method

//     when(mockAuthUseCase.loginUser('ayusha20', 'sAyusha1'))
//         .thenAnswer((_) async => Right(isLogin));
//     when(mockHomeUseCase.getAllArt())
//         .thenAnswer((_) async => Right(homeEntity));
//     when(mockProfileUseCase.getUserProfile())
//         .thenAnswer((_) async => Right(profileEntity));
//     when(mockHomeUseCase.getUserArts())
//         .thenAnswer((_) async => Right(homeEntity));
//     when(mockHomeUseCase.getSavedArts())
//         .thenAnswer((_) async => const Right([]));
//     when(mockHomeUseCase.getAlertArts())
//         .thenAnswer((_) async => const Right([]));
    

//     await tester.pumpWidget(
//       ProviderScope(
//         overrides: [
//           authViewModelProvider
//               .overrideWith((ref) => AuthViewModel(mockAuthUseCase)),
//           homeViewModelProvider
//               .overrideWith((ref) => HomeViewModel(mockHomeUseCase)),
//           profileViewModelProvider
//               .overrideWith((ref) => ProfileViewModel(mockProfileUseCase)),
          
//         ],
//         child: MaterialApp(
//           initialRoute: AppRoute.loginRoute,
//           routes: AppRoute.getApplicationRoute(),
//         ),
//       ),
//     );
//     await tester.pumpAndSettle();

//     // Type in first textformfield/TextField
//     await tester.enterText(find.byType(TextFormField).at(0), 'ayusha20');
//     // Type in second textformfield
//     await tester.enterText(find.byType(TextFormField).at(1), 'sAyusha1');

//     await tester.tap(
//       find.widgetWithText(ElevatedButton, 'LOGIN'),
//     );

//     await tester.pumpAndSettle();

//     expect(find.text('AUCTIONS'), findsOneWidget);

//     // expect(find., matcher)
//   });
// }
