final class CustomerEntity {
  const CustomerEntity({this.id = '', this.name = ''});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerEntity && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hashAll([id, name]);
}
