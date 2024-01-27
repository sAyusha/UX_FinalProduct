import 'package:equatable/equatable.dart';

class PostEntity extends Equatable{
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

  const PostEntity({
    this.artId,
    required this.image,
    required this.title,
    required this.creator,
    required this.description,
    required this.startingBid,
    required this.endingDate,
    required this.artType,
    required this.upcomingDate,
    required this.categories,
  });

  //to json
  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      artId: json['id'],
      image: json['image'],
      title: json['title'],
      creator: json['creator'],
      description: json['description'],
      startingBid: json['startingBid'],
      endingDate: DateTime.parse(json['endingDate']),
      artType: json['artType'],
      upcomingDate: DateTime.parse(json['upcomingDate']),
      categories: json['categories'],
    );
  }

  // from json
  Map<String, dynamic> toJson() {
    return {
      'id': artId,
      'image': image,
      'title': title,
      'creator': creator,
      'description': description,
      'startingBid': startingBid.toDouble(),
      'endingDate': endingDate.toString(),
      'artType': artType,
      'upcomingDate': upcomingDate.toString(),
      'categories': categories,
    };
  }

  @override
  String toString() {
    return 'PostEntity(artId: $artId, image: $image, title: $title, creator: $creator, description: $description, startingBid: $startingBid, endingDate: $endingDate, artType: $artType, upcomingDate:$upcomingDate, categories: $categories)';
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