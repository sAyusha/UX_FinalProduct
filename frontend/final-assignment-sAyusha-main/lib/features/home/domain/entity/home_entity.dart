import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
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
  final bool ? artExpired;

  const HomeEntity({
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

  // from JSON
  factory HomeEntity.fromJson(Map<String, dynamic> json) {
    return HomeEntity(
      artId: json['_id'],
      title: json['title'],
      description: json['description'],
      creator: json['creator'],
      image: json['image'],
      profileImage: json['profileImage'],
      endingDate: json['endingDate'],
      startingBid: json['startingBid'],
      artType: json['artType'],
      upcomingDate: json['upcomingDate'],
      categories: json['categories'],
      isSaved: json['isSaved'],
      isAlert: json['isAlert'],
      isUserLoggedIn: json['isUserLoggedIn'],
      artExpired: json['artExpired'],
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'artId': artId,
      'title': title,
      'description': description,
      'creator': creator,
      'image': image,
      'profileImage': profileImage,
      'endingDate': endingDate,
      'startingBid': startingBid,
      'artType': artType,
      'upcomingDate': upcomingDate,
      'categories': categories,
      'isSaved': isSaved,
      'isAlert': isAlert,
      'isUserLoggedIn': isUserLoggedIn,
      'artExpired': artExpired,
    };
  }

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
