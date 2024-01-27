import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String? profileImage;
  final String fullname;
  final String username;
  final String email;
  final String? phone;
  final String? bio;
  // final List<String> savedPosts;

  const ProfileEntity({
    this.userId,
    this.profileImage,
    required this.fullname,
    required this.username,
    required this.email,
    this.phone,
    this.bio,
    // required this.savedPosts,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) => ProfileEntity(
        userId: json["userId"],
        profileImage: json["profileImage"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        bio: json["bio"],
        // savedPosts: List<String>.from(json["savedPosts"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "profileImage": profileImage,
        "fullname": fullname,
        "username": username,
        "email": email,
        "phone": phone,
        "bio": bio,
        // "savedPosts": List<dynamic>.from(savedPosts.map((x) => x)),
      };

  @override
  List<Object?> get props => [
        userId,
        profileImage,
        fullname,
        username,
        phone,
        bio,
        email,
        // savedPosts,
      ];
}