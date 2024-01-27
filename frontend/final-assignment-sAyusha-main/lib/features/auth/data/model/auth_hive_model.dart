import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../config/constants/hive_table_constant.dart';
import '../../domain/entity/user_entity.dart';

part 'auth_hive_model.g.dart';

final authHiveModelProvider = Provider(
  (ref) => AuthHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel {
  @HiveField(0)
  final String? fullname;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String? password;

  // Constructor
  AuthHiveModel({
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });

  // empty constructor
  AuthHiveModel.empty()
      : this(
          fullname: '',
          username: '',
          email: '',
          phone: '',
          password: '',
        );

  // Convert Hive Object to Entity
  UserEntity toEntity() => UserEntity(
        fullname: fullname,
        username: username,
        email: email,
        phone: phone,
        password: password,
      );

  // Convert Entity to Hive Object
  AuthHiveModel toHiveModel(UserEntity entity) => AuthHiveModel(
        fullname: entity.fullname,
        username: entity.username,
        email: entity.email,
        phone: entity.phone,
        password: entity.password,
      );

  // Convert Entity List to Hive List
  List<AuthHiveModel> toHiveModelList(List<UserEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  @override
  String toString() {
    return 'AuthHiveModel (fullname: $fullname, username: $username, email: $email, phone: $phone, password: $password)';
  }
}
