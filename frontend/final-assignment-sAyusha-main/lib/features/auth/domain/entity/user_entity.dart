import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? fullname;
  final String? username;
  final String? email;
  final String? phone;
  final String? password;

  const UserEntity({
    this.fullname,
    this.username,
    this.email,
    this.phone,
    this.password,
  });
  
  @override
  List<Object?> get props => [fullname, username, email, phone, password];
}


