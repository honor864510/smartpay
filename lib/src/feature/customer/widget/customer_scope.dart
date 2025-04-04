import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizzle_starter/src/feature/customer/bloc/customer_bloc.dart';
import 'package:sizzle_starter/src/feature/customer/model/customer_entity.dart';

/// {@template customer_scope}
/// CustomerScope widget.
/// {@endtemplate}
class CustomerScope extends StatefulWidget {
  /// {@macro customer_scope}
  const CustomerScope({required this.child, super.key});

  /// The child widget.
  final Widget child;

  /// Get the [CustomerBloc] instance.
  static CustomerBloc of(BuildContext context, {bool listen = true}) {
    final customerScope =
        listen
            ? context.dependOnInheritedWidgetOfExactType<_InheritedCustomer>()
            : context.getInheritedWidgetOfExactType<_InheritedCustomer>();
    return customerScope!.state._customerBloc;
  }

  /// Get the [CustomerEntity] instance.
  static CustomerEntity customerOf(BuildContext context, {bool listen = true}) {
    final customerScope =
        listen
            ? context.dependOnInheritedWidgetOfExactType<_InheritedCustomer>()
            : context.getInheritedWidgetOfExactType<_InheritedCustomer>();
    return customerScope!.customer ?? const CustomerEntity();
  }

  @override
  State<CustomerScope> createState() => _CustomerScopeState();
}

/// State for widget CustomerScope.
class _CustomerScopeState extends State<CustomerScope> {
  late final CustomerBloc _customerBloc;

  @override
  void initState() {
    super.initState();
    // TODO find how to instanciate bloc properly
    // final customerRepository = DependenciesScope.of(context).customerRepository;
    // _customerBloc = CustomerBloc(
    //   customerRepository: customerRepository,
    //   initialState: const CustomerState.idle(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: _customerBloc,
      builder:
          (context, state) =>
              _InheritedCustomer(customer: state.customer, state: this, child: widget.child),
    );
  }
}

/// {@template inherited_customer}
/// _InheritedCustomer widget.
/// {@endtemplate}
class _InheritedCustomer extends InheritedWidget {
  /// {@macro inherited_customer}
  const _InheritedCustomer({required super.child, required this.state, required this.customer});

  /// _CustomerScopeState instance.
  final _CustomerScopeState state;
  final CustomerEntity? customer;

  @override
  bool updateShouldNotify(covariant _InheritedCustomer oldWidget) => customer != oldWidget.customer;
}
