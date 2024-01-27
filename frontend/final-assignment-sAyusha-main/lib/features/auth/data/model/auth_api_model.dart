import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/user_entity.dart';

part 'auth_api_model.g.dart';

// create provider for AuthApiModel
final authApiModelProvider = Provider<AuthApiModel>((ref) {
  return AuthApiModel(
    fullname: '',
    username: '',
    email: '',
    phone: '',
    password: '',
  );
});

@JsonSerializable()
class AuthApiModel{
  @JsonKey(name: 'fullname')
  final String? fullname;

  @JsonKey(name: 'username')
  final String? username;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'password')
  final String? password;

  // Constructor
  AuthApiModel({
    this.fullname,
    this.username,
    this.email,
    this.phone,
    this.password,
  });

  // to JSON
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) => _$AuthApiModelFromJson(json);

  // Convert AuthApiModel to UserEntity
  UserEntity toEntity() => UserEntity(
    fullname: fullname,
    username: username,
    email: email,
    phone: phone,
    password: password,
  );

  // Convert AUthApiModel list to UserEntity list
  List<UserEntity> listFromJson(List<AuthApiModel> models) => 
    models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'AuthApiModel(fullname: $fullname, username: $username, email: $email, phone: $phone, password: $password)';
  }
}