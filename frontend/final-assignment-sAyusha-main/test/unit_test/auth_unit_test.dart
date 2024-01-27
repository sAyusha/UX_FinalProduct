import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_final_assignment/features/auth/domain/use_case/auth_usecase.dart';
import 'package:flutter_final_assignment/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AuthUseCase mockAuthUseCase;
  late ProviderContainer container;
  late BuildContext context;
  late UserEntity userEntity;

  setUpAll(() {
    mockAuthUseCase = MockAuthUseCase();
    userEntity = const UserEntity(
        fullname: 'siddhartha shakya',
        username: 'siddhartha',
        email: 'sid123@gmail.com',
        phone: '9865258511',
        password: 'sid123');
    container = ProviderContainer(
      overrides: [
        authViewModelProvider.overrideWith(
          (ref) => AuthViewModel(mockAuthUseCase),
        ),
      ],
    );
    context = MockBuildContext();
  });

  test('check for the initial state', () async {
    final authState = container.read(authViewModelProvider);
    expect(authState.isLoading, false);
  });

  test('register test with valid credentials', () async {
    when(mockAuthUseCase.registerUser(userEntity))
        .thenAnswer((_) => Future.value(const Right(true)));

    //comparing viewmodel ko loginStudent with mock ko
    await container.read(authViewModelProvider.notifier).registerUser(context,
        const UserEntity(
            fullname: 'siddhartha shakya',
            username: 'siddhartha',
            email: 'sid123@gmail.com',
            phone: '9865258511',
            password: 'sid123'));

    // state check
    final authState = container.read(authViewModelProvider);
    expect(authState.error, isNull);
  });
  test('login test with valid username and password', () async {
    when(mockAuthUseCase.loginUser('siddhartha', 'sid123'))
        .thenAnswer((_) => Future.value(const Right(true)));

    //comparing logiUser of viemodel with mock object
    await container
        .read(authViewModelProvider.notifier)
        .loginUser(context, 'siddhartha', 'sid123');

    // state check
    final authState = container.read(authViewModelProvider);
    expect(authState.error, null);
  });

  test('login test with invalid username and password', () async {
    when(mockAuthUseCase.loginUser('siddharthaa', 'sid1234'))
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));

    //comparing logiUser of viemodel with mock object
    await container
        .read(authViewModelProvider.notifier)
        .loginUser(context, 'siddharthaa', 'sid1234');

    // state check
    final authState = container.read(authViewModelProvider);
    expect(authState.error, isNotNull);
    // expect(authState.error, 'Invalid');
  });


  test('register test with invalid credentials', () async {
    when(mockAuthUseCase.registerUser(const UserEntity(
            fullname: 'siddhartha shrestha',
            username: 'siddharthaa',
            email: 'sid1234@gmail.com',
            phone: '9865258522',
            password: 'sid1234')))
        .thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid'))));

    //comparing viewmodel ko loginStudent with mock ko
    await container
        .read(authViewModelProvider.notifier)
        .registerUser(context, const UserEntity(
            fullname: 'siddhartha shrestha',
            username: 'siddharthaa',
            email: 'sid1234@gmail.com',
            phone: '9865258522',
            password: 'sid1234'));

    // state check
    final authState = container.read(authViewModelProvider);
    expect(authState.error, isNotNull);
  });

  tearDownAll(() {
    container.dispose();
  });
}
