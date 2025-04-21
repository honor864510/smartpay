import 'package:flutter/material.dart';
import 'package:smartpay/src/common/model/dependencies.dart';
import 'package:smartpay/src/common/navigator/app_navigator.dart';
import 'package:smartpay/src/common/navigator/app_route_observer.dart';
import 'package:smartpay/src/common/navigator/authentication_guard.dart';
import 'package:smartpay/src/common/navigator/routes.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final ValueNotifier<NavigationState> navigationController;
  late final ValueNotifier<List<({Object error, StackTrace stackTrace})>> errorsObserver;
  AuthenticationGuard? authGuard;

  @override
  void initState() {
    super.initState();

    // Initialize errors observer
    errorsObserver = ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
      <({Object error, StackTrace stackTrace})>[],
    );

    // Initialize navigation controller without a route
    navigationController = ValueNotifier<NavigationState>([]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dependencies = Dependencies.of(context);

    authGuard = AuthenticationGuard(
      getUser: () => dependencies.authenticationController.state.user,
      authRoutes: {Routes.signIn},
      defaultAuthRoute: Routes.signIn,
      defaultHomeRoute: Routes.dashboard,
    );

    // Set initial route after auth guard is initialized
    if (navigationController.value.isEmpty) {
      final initialRoute = Routes.dashboard.page();
      final guardedPages = authGuard?.call([initialRoute]) ?? [initialRoute];
      navigationController.value = guardedPages;
    }
  }

  @override
  void dispose() {
    navigationController.dispose();
    errorsObserver.dispose();
    super.dispose();
  }

  // Helper methods for navigation
  void navigateTo(Routes route, {Map<String, Object?>? arguments}) {
    navigationController.value = [...navigationController.value, route.page(arguments: arguments)];
  }

  void replaceWith(Routes route, {Map<String, Object?>? arguments}) {
    final newPages = [...navigationController.value];
    if (newPages.isNotEmpty) {
      newPages.removeLast();
    }
    newPages.add(route.page(arguments: arguments));
    navigationController.value = newPages;
  }

  void replaceAllWith(Routes route, {Map<String, Object?>? arguments}) {
    navigationController.value = [route.page(arguments: arguments)];
  }

  void pop() {
    if (navigationController.value.length > 1) {
      final newPages = [...navigationController.value]..removeLast();
      navigationController.value = newPages;
    }
  }

  // Build the navigator
  Widget buildNavigator() => AppNavigator.controlled(
    controller: navigationController,
    revalidate: Dependencies.of(context).authenticationController,
    guards: [
      if (authGuard != null)
        (pages) {
          try {
            return authGuard!(pages);
          } on Object catch (error, stackTrace) {
            errorsObserver.value = [(error: error, stackTrace: stackTrace), ...errorsObserver.value];
            return pages;
          }
        },
    ],
    observers: [AppRouteObserver()],
  );
}
