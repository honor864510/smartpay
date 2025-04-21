import 'package:meta/meta.dart';

@immutable
final class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    this.password = '',
    this.name = '',
    this.avatar = '',
    this.type = '',
    this.verified = false,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
    verified: json['verified'] as bool,
  );

  final String id;
  final String email;
  final String password;
  final String name;
  final String avatar;
  final String type;
  final bool verified;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'avatar': avatar,
    'type': type,
    'verified': verified,
  };

  UserDto copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? avatar,
    String? type,
    bool? verified,
  }) => UserDto(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    type: type ?? this.type,
    verified: verified ?? this.verified,
  );

  @override
  int get hashCode => Object.hashAll([id, email, password, name, avatar, type, verified]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          id == other.id &&
          email == other.email &&
          password == other.password &&
          name == other.name &&
          avatar == other.avatar &&
          type == other.type &&
          verified == other.verified;
}
