import 'package:sizzle_starter/src/feature/customer/model/customer_entity.dart';

/// {@template customer_repository}
/// [CustomerRepository]
/// {@endtemplate}
abstract interface class CustomerRepository {
  /// Creates a new customer
  Future<CustomerEntity> create(CustomerEntity customer);

  /// Retrieves a customer by their ID
  Future<CustomerEntity?> fetchById(String id);

  /// Updates an existing customer
  Future<CustomerEntity> update(CustomerEntity customer);

  /// Deletes a customer by their ID
  Future<void> delete(String id);

  /// Retrieves all customers
  Future<List<CustomerEntity>> fetchAll();
}
