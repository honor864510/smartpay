import 'package:meta/meta.dart';

@immutable
final class UserDto {
  const UserDto({required this.id, required this.email, this.password = '', this.name = '', this.avatar = ''});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
  );

  final String id;
  final String email;
  final String password;
  final String name;
  final String avatar;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'avatar': avatar,
  };

  UserDto copyWith({String? id, String? email, String? password, String? name, String? avatar}) => UserDto(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
  );

  @override
  int get hashCode => Object.hashAll([id, email, password, name, avatar]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          id == other.id &&
          email == other.email &&
          password == other.password &&
          name == other.name &&
          avatar == other.avatar;
}
