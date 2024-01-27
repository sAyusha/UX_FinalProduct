import 'package:equatable/equatable.dart';
import 'package:flutter_final_assignment/features/home/domain/entity/home_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_api_model.g.dart';

// create provider for HomeApiModel
final homeApiModelProvider = Provider.autoDispose<HomeApiModel>(
  (ref) => HomeApiModel.empty(),
);

@JsonSerializable()
class HomeApiModel extends Equatable{
  @JsonKey(name: '_id')
  final String? artId;
  final String title;
  final String description;
  final String creator;
  final String? image;
  final String? profileImage;
  final DateTime endingDate;
  final num startingBid;
  final String artType;
  final DateTime upcomingDate;
  final String categories;
  final bool? isSaved;
  final bool? isAlert;
  final bool? isUserLoggedIn;
  final bool? artExpired;

  const HomeApiModel({
    this.artId,
    required this.title,
    required this.description,
    required this.creator,
    this.image,
    this.profileImage,
    required this.endingDate,
    required this.startingBid,
    required this.artType,
    required this.upcomingDate,
    required this.categories,
    this.isSaved,
    this.isAlert,
    this.isUserLoggedIn,
    this.artExpired,
  });

  // empty constructor
  HomeApiModel.empty()
      : artId = '',
        title = '',
        description = '',
        creator = '',
        image = '',
        profileImage = '',
        endingDate = DateTime.now(),
        startingBid = 0,
        artType = '',
        upcomingDate = DateTime.now(),
        categories = '',
        isSaved = false,
        isAlert = false,
        isUserLoggedIn = false,
        artExpired = false;

  // from JSON
  factory HomeApiModel.fromJson(Map<String, dynamic> json) =>
      _$HomeApiModelFromJson(json);

  //to JSON
  Map<String, dynamic> toJson() => _$HomeApiModelToJson(this);

  // convert API Object to Entity
  HomeEntity toEntity() => HomeEntity(
        artId: artId,
        title: title,
        description: description,
        creator: creator,
        image: image,
        profileImage: profileImage,
        endingDate: endingDate,
        startingBid: startingBid,
        artType: artType,
        upcomingDate: upcomingDate,
        categories: categories,
        isSaved: isSaved ?? false,
        isAlert: isAlert ?? false,
        isUserLoggedIn: isUserLoggedIn ?? false,
        artExpired: artExpired ?? false,
      );
  
  // convert Entity to API Object
  HomeApiModel fromEntity(HomeEntity entity) => HomeApiModel(
        artId: entity.artId ?? '',
        title: entity.title,
        description: entity.description,
        creator: entity.creator,
        image: entity.image ?? '',
        profileImage: entity.profileImage ?? '',
        endingDate: entity.endingDate,
        startingBid: entity.startingBid,
        artType: entity.artType,
        upcomingDate: entity.upcomingDate,
        categories: entity.categories,
        isSaved: entity.isSaved ?? false,
        isAlert: entity.isAlert ?? false,
        isUserLoggedIn: entity.isUserLoggedIn ?? false,
        artExpired: entity.artExpired ?? false,
      );

  // convert API list to Entity list
  List<HomeEntity> toEntityList(List<HomeApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  // to string
  @override
  String toString() {
    return 'HomeApiModel(artId: $artId, title: $title, description: $description, creator: $creator, image: $image, profileImage: $profileImage, endingDate: $endingDate, startingBid: $startingBid, artType: $artType, upcomingDate: $upcomingDate, categories: $categories, isSaved: $isSaved, isAlert: $isAlert, isUserLoggedIn: $isUserLoggedIn, artExpired: $artExpired)';
  }

  @override
  List<Object?> get props => [
        artId,
        title,
        description,
        creator,
        image,
        profileImage,
        endingDate,
        startingBid,
        artType,
        upcomingDate,
        categories,
        isSaved,
        isAlert,
        isUserLoggedIn,
        artExpired,
      ];
}