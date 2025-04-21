import 'package:meta/meta.dart';

/// User id type.
typedef UserId = String;

/// User type enum
enum UserType {
  partner,
  client;

  factory UserType.fromString(String? value) => switch (value) {
    'client' => UserType.client,
    'partner' => UserType.partner,
    _ => UserType.client,
  };

  bool get isPartner => this == UserType.partner;
  bool get isClient => this == UserType.client;

  @override
  String toString() => isClient ? 'client' : 'partner';
}

/// {@template user}
/// The user entry model.
/// {@endtemplate}
@immutable
sealed class User with _UserPatternMatching, _UserShortcuts {
  /// {@macro user}
  const User._();

  /// {@macro user}
  @literal
  const factory User.unauthenticated() = UnauthenticatedUser;

  /// {@macro user}
  const factory User.authenticated({
    required UserId id,
    required UserType type,
    required String customerId,
    required String email,
  }) = AuthenticatedUser;

  /// {@macro user}
  factory User.fromJson(Map<String, Object?> json) => switch ((
    json['id'],
    json['type'],
    json['customerId'],
    json['email'],
  )) {
    (UserId id, String type, String customerId, String email) => AuthenticatedUser(
      id: id,
      type: UserType.values.firstWhere((e) => e.name == type, orElse: () => UserType.client),
      customerId: customerId,
      email: email,
    ),
    _ => const UnauthenticatedUser(),
  };

  /// The user's id.
  abstract final UserId? id;

  /// The user's type.
  abstract final UserType? type;

  /// The user's customer id.
  abstract final String? customerId;

  /// The user's phone number.
  abstract final String? email;

  Map<String, Object?> toJson();
}

/// {@macro user}
///
/// Unauthenticated user.
class UnauthenticatedUser extends User {
  /// {@macro user}
  const UnauthenticatedUser() : super._();

  @override
  UserId? get id => null;

  @override
  UserType? get type => null;

  @override
  String? get customerId => null;

  @override
  String? get email => null;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'user',
    'status': 'unauthenticated',
    'authenticated': false,
    'id': null,
    'userType': null,
    'customerId': null,
    'email': null,
  };

  @override
  bool get isAuthenticated => false;

  @override
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  }) => unauthenticated(this);

  @override
  int get hashCode => -1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnauthenticatedUser &&
          id == other.id &&
          email == other.email &&
          type == other.type &&
          customerId == other.customerId;

  @override
  String toString() => 'UnauthenticatedUser{}';

  @override
  User copyWith({UserId? id, UserType? type, String? email, String? customerId}) {
    if (id == null && this.id == null) return this;

    if (type == null && this.type == null) return this;

    if (email == null && this.email == null) return this;

    if (customerId == null && this.customerId == null) return this;

    return AuthenticatedUser(
      id: id ?? this.id!,
      type: type ?? this.type!,
      customerId: customerId ?? this.customerId!,
      email: email ?? this.email!,
    );
  }
}

/// {@macro user}
final class AuthenticatedUser extends User {
  /// {@macro user}
  const AuthenticatedUser({required this.id, required this.type, required this.customerId, required this.email})
    : super._();

  @override
  @nonVirtual
  final UserId id;

  @override
  @nonVirtual
  final UserType type;

  @override
  @nonVirtual
  final String customerId;

  @override
  @nonVirtual
  final String email;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'user',
    'status': 'authenticated',
    'authenticated': true,
    'id': id,
    'userType': type.name,
    'customerId': customerId,
    'email': email,
  };

  @override
  AuthenticatedUser copyWith({UserId? id, UserType? type, String? customerId, String? email}) => AuthenticatedUser(
    id: id ?? this.id,
    type: type ?? this.type,
    customerId: customerId ?? this.customerId,
    email: email ?? this.email,
  );

  @override
  bool get isAuthenticated => true;

  @override
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  }) => authenticated(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthenticatedUser && id == other.id;

  @override
  String toString() => 'AuthenticatedUser{id: $id}';
}

mixin _UserPatternMatching {
  /// Pattern matching on [User] subclasses.
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  });

  /// Pattern matching on [User] subclasses.
  T maybeMap<T>({
    required T Function() orElse,
    T Function(UnauthenticatedUser user)? unauthenticated,
    T Function(AuthenticatedUser user)? authenticated,
  }) => map<T>(
    unauthenticated: (user) => unauthenticated?.call(user) ?? orElse(),
    authenticated: (user) => authenticated?.call(user) ?? orElse(),
  );

  /// Pattern matching on [User] subclasses.
  T? mapOrNull<T>({
    T Function(UnauthenticatedUser user)? unauthenticated,
    T Function(AuthenticatedUser user)? authenticated,
  }) => map<T?>(
    unauthenticated: (user) => unauthenticated?.call(user),
    authenticated: (user) => authenticated?.call(user),
  );
}

mixin _UserShortcuts on _UserPatternMatching {
  /// User is authenticated.
  bool get isAuthenticated;

  /// User is not authenticated.
  bool get isNotAuthenticated => !isAuthenticated;

  /// Copy with new values.
  User copyWith({UserId? id, UserType? type, String? customerId, String? email});
}
