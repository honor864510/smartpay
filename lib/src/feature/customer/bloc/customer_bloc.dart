import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/feature/customer/data/customer_repository.dart';
import 'package:sizzle_starter/src/feature/customer/model/customer_entity.dart';

/// {@template app_settings_bloc}
/// A [Bloc] that handles [CustomerEntity].
/// {@endtemplate}
final class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  /// {@macro app_settings_bloc}
  CustomerBloc({
    required CustomerRepository customerRepository,
    required CustomerState initialState,
  }) : _customerRepository = customerRepository,
       super(initialState) {
    on<CustomerEvent>(
      (event, emit) => switch (event) {
        final _CustomerEvent$Update e => _updateCustomer(e, emit),
      },
    );
  }

  final CustomerRepository _customerRepository;

  Future<void> _updateCustomer(_CustomerEvent$Update event, Emitter<CustomerState> emit) async {
    try {
      emit(_CustomerState$Loading(customer: state.customer));
      await _customerRepository.update(event.customer);
      emit(_CustomerState$Idle(customer: event.customer));
    } catch (error) {
      emit(_CustomerState$Error(customer: event.customer, error: error));
    }
  }
}

/// States for the [CustomerBloc].
sealed class CustomerState {
  const CustomerState({this.customer});

  /// Application locale.
  final CustomerEntity? customer;

  /// The customer are idle.
  const factory CustomerState.idle({CustomerEntity? customer}) = _CustomerState$Idle;

  /// The customer are loading.
  const factory CustomerState.loading({CustomerEntity? customer}) = _CustomerState$Loading;

  /// The customer have an error.
  const factory CustomerState.error({required Object error, CustomerEntity? customer}) =
      _CustomerState$Error;
}

final class _CustomerState$Idle extends CustomerState {
  const _CustomerState$Idle({super.customer});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _CustomerState$Idle && other.customer == customer;
  }

  @override
  int get hashCode => customer.hashCode;

  @override
  String toString() => 'CustomerState.idle(customer: $customer)';
}

final class _CustomerState$Loading extends CustomerState {
  const _CustomerState$Loading({super.customer});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _CustomerState$Loading && other.customer == customer;
  }

  @override
  int get hashCode => customer.hashCode;

  @override
  String toString() => 'CustomerState.loading(customer: $customer)';
}

final class _CustomerState$Error extends CustomerState {
  const _CustomerState$Error({required this.error, super.customer});

  /// The error.
  final Object error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _CustomerState$Error && other.customer == customer && other.error == error;
  }

  @override
  int get hashCode => Object.hash(customer, error);

  @override
  String toString() => 'CustomerState.error(customer: $customer, error: $error)';
}

/// Events for the [CustomerBloc].
sealed class CustomerEvent {
  const CustomerEvent();

  /// Update the customer.
  const factory CustomerEvent.updateCustomer({required CustomerEntity customer}) =
      _CustomerEvent$Update;
}

final class _CustomerEvent$Update extends CustomerEvent {
  const _CustomerEvent$Update({required this.customer});

  /// The theme to update.
  final CustomerEntity customer;

  @override
  String toString() => 'CustomerEvent.updateCustomer(customer: $customer)';
}
