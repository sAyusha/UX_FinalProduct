import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_assignment/core/failure/failure.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_final_assignment/features/post/domain/use_case/post_use_case.dart';
import 'package:flutter_final_assignment/features/post/presentation/viewmodel/post_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_unit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PostUseCase>(),
  MockSpec<BuildContext>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PostUseCase mockPostUseCase;
  late ProviderContainer container;
  late BuildContext context;
  late PostEntity postEntity;

  setUpAll(() {
    mockPostUseCase = MockPostUseCase();
    postEntity = PostEntity(
      image: "IMG-1690725538470.jpg",
      title: 'Children Fantasy Art',
      creator: 'Jake Daniel',
      description: 'This is a fantsy art of children. It is a digital art.',
      artType: "Recent",
      startingBid: 599.69,
      upcomingDate: DateTime.parse("2023-08-20 11:29"),
      categories: "Painting",
      endingDate: DateTime(2023, 7, 10, 18, 0, 0),
    );
    container = ProviderContainer(
      overrides: [
        postViewModelProvider.overrideWith(
          (ref) => PostViewModel(mockPostUseCase),
        ),
      ],
    );
    context = MockBuildContext();
  });

  test('check for the initial state', () async {
    final postState = container.read(postViewModelProvider);
    expect(postState.isLoading, false);
  });

  // test case: post art with valid data
  test('post art test with valid data', () async {
    when(mockPostUseCase.postArt(postEntity))
        .thenAnswer((_) => Future.value(const Right(true)));

    //comparing postArt of viemodel with mock object
    await container.read(postViewModelProvider.notifier).postArt(
        context,
        PostEntity(
          image: "IMG-1690725538470.jpg",
          title: 'Children Fantasy Art',
          creator: 'Jake Daniel',
          description: 'This is a fantsy art of children. It is a digital art.',
          artType: "Recent",
          startingBid: 599.69,
          upcomingDate: DateTime.parse("2023-08-20 11:29"),
          categories: "Painting",
          endingDate: DateTime(2023, 7, 10, 18, 0, 0),
        ));

    // state check
    final postState = container.read(postViewModelProvider);
    expect(postState.error, null);
  });

  // test case: post art with invalid data
  test('post art test with invalid data', () async {
    when(mockPostUseCase.postArt(PostEntity(
      image: "IMG-1690725538470.jpg",
      title: 'Children Fantasy Art', 
      creator: 'Jake Daniel', 
      description: 'This is a fantsy art of children. It is a digital art.', 
      artType: "Recent",
      startingBid: 599.69, 
      upcomingDate: DateTime.parse("2023-08-20 11:29"),
      categories: "Painting",
      endingDate: DateTime(2023, 7, 10, 18, 0, 0),
    ))).thenAnswer((_) => Future.value(Left(Failure(error: 'Invalid data'))));

    //comparing postArt of viemodel with mock object
    await container.read(postViewModelProvider.notifier).postArt(
        context,
        PostEntity(
          image: "sss",
          title: 'Children Fantasy',
          creator: 'Jake ',
          description:
              'This is a fantasy art of children. It is a digital art.',
          artType: "null",
          startingBid: 599.78,
          endingDate: DateTime(2023, 7, 10, 18, 0, 0),
          upcomingDate: DateTime.parse("2023-08-20 11:29"),
          categories: "Painting",
        ));

    // state check
    final postState = container.read(postViewModelProvider);
    expect(postState.error, isNull);
  });

  tearDownAll(() {
    container.dispose();
  });
}
