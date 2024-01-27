import 'package:equatable/equatable.dart';
import 'package:flutter_final_assignment/features/post/domain/entity/post_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_api_model.g.dart';

// provider for PostApiModel
final postApiModelProvider = Provider.autoDispose<PostApiModel>(
  (ref) => PostApiModel.empty(),
);

@JsonSerializable()
class PostApiModel extends Equatable{
  @JsonKey(name: '_id')
  final String? artId;
  final String image;
  final String title;
  final String creator;
  final String description;
  final num startingBid;
  final DateTime endingDate;
  final String artType;
  final DateTime upcomingDate;
  final String categories;

  const PostApiModel({
    this.artId,
    required this.image,
    required this.title,
    required this.creator,
    required this.description,
    required this.startingBid,
    required this.endingDate,
    required this.artType,
    required this.upcomingDate,
    required this.categories
  });

  // empty constructor
  PostApiModel.empty()
    : artId = '',
      image = '',
      title = '',
      creator = '',
      description = '',
      startingBid = 0,
      endingDate = DateTime.now(),
      artType = '',
      upcomingDate = DateTime.now(),
      categories = '';

  // to json
  factory PostApiModel.fromJson(
    Map<String, dynamic> json) => 
      _$PostApiModelFromJson(json);

  // from json
  Map<String, dynamic> toJson() => 
    _$PostApiModelToJson(this);

  // convert PostApiModel to PostEntity
  PostEntity toEntity() => PostEntity(
    artId: artId,
    image: image,
    title: title,
    creator: creator,
    description: description,
    startingBid: startingBid,
    endingDate: endingDate,
    artType: artType,
    upcomingDate: upcomingDate,
    categories: categories,
  );

  // convert entity to api object
  PostApiModel fromEntity(PostEntity entity) => PostApiModel(
    artId: entity.artId ?? '',
    image: entity.image,
    title: entity.title,
    creator: entity.creator,
    description: entity.description,
    startingBid: entity.startingBid,
    endingDate: entity.endingDate,
    artType: entity.artType,
    upcomingDate: entity.upcomingDate,
    categories: entity.categories,
  );

  // convert PostApiModel list to PostEntity list
  List<PostEntity> toEntityList(List<PostApiModel> models) =>
    models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'PostApiModel(artId: $artId, image: $image, title: $title, creator: $creator, description: $description, startingBid: $startingBid, endingDate: $endingDate, artType: $artType, upcomingDate: $upcomingDate, categories: $categories)';
  }
  
  @override
  List<Object?> get props => [
    artId,
    image,
    title,
    creator,
    description,
    startingBid,
    endingDate,
    artType,
    upcomingDate,
    categories,
  ];
}