// import 'package:flutter_final_assignment/features/home/data/model/home_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_table_constant.dart';
import '../../domain/entity/home_entity.dart';
// import 'package:uuid/uuid.dart';

part 'home_hive_model.g.dart';

final homeHiveModelProvider = Provider(
  (ref) => HomeHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.homeTableId)
class HomeHiveModel {
  @HiveField(0)
  final String? artId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String creator;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final num startingBid;

  @HiveField(6)
  final DateTime endingDate;

  @HiveField(7)
  final String artType;

  @HiveField(8)
  final String categories;

  @HiveField(9)
  final bool? isSaved;

  @HiveField(10)
  final bool? isAlert;

  @HiveField(11)
  final DateTime upcomingDate;


  // empty constructor
  HomeHiveModel.empty()
      : artId = '',
        title = '',
        description = '',
        creator = '',
        image = '',
        endingDate = DateTime.now(),
        startingBid = 0,
        artType = '',
        categories = '',
        isSaved = false,
        isAlert = false,
        upcomingDate = DateTime.now();

  HomeHiveModel({
    String? artId,
    required this.title,
    required this.description,
    required this.creator,
    required this.image,
    required this.startingBid,
    required this.endingDate,
    required this.artType,
    required this.categories,
    this.isSaved,
    this.isAlert,
    required this.upcomingDate,
  }): artId = artId ?? const Uuid().v4();

  //Convert Hive Object to Entity
  HomeEntity toEntity() => HomeEntity(
        artId: artId,
        title: title,
        description: description,
        creator: creator,
        image: image,
        startingBid: startingBid,
        endingDate: endingDate,
        artType: artType,
        categories: categories,
        isSaved: isSaved,
        isAlert: isAlert,
        upcomingDate: upcomingDate,
      );

  // convert entity to hive object
  HomeHiveModel toHiveModel(HomeEntity entity) => HomeHiveModel(
        artId: entity.artId,
        title: entity.title,
        description: entity.description,
        creator: entity.creator,
        image: entity.image.toString(),
        startingBid: entity.startingBid,
        endingDate: entity.endingDate,
        artType: entity.artType,
        categories: entity.categories,
        isSaved: entity.isSaved,
        isAlert: entity.isAlert,
        upcomingDate: entity.upcomingDate,
  );

  // List<HomeHiveModel> fromApiModelList(
  //     List<HomeApiModel> apiModels) {
  //   return apiModels
  //       .map((apiModel) => HomeHiveModel(
  //             artId: apiModel.artId,
  //             title: apiModel.title,
  //             description: apiModel.description,
  //             creator: apiModel.creator,
  //             image: apiModel.image ?? '',
  //             startingBid: apiModel.startingBid,
  //             endingDate: apiModel.endingDate,
  //             artType: apiModel.artType,
  //             categories: apiModel.categories,
  //             isSaved: apiModel.isSaved,
  //             isAlert: apiModel.isAlert,
  //             upcomingDate: apiModel.upcomingDate,

  //           ))
  //       .toList();
  // }

  // Convert Hive List to Entity List
  List<HomeEntity> toEntityList(List<HomeHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  // to string
  @override
  String toString(){
    return 'artId: $artId, title: $title, description: $description, creator: $creator, image: $image, startingBid: $startingBid, endingDate: $endingDate, artType: $artType, categories: $categories, isSaved: $isSaved, isAlert: $isAlert, upcomingDate: $upcomingDate';
  }
}
