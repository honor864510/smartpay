import 'package:flutter/material.dart';
import 'package:l/l.dart';

final class AppRouteObserver extends NavigatorObserver {
  /// Logs a navigation event with the current route information
  void _logNavigationEvent(String event, {Route<dynamic>? current, Route<dynamic>? previous}) {
    final currentRoute = _getRouteInfo(current);
    final previousRoute = _getRouteInfo(previous);

    l.i('$event - Current: $currentRoute, Previous: $previousRoute');
  }

  /// Extracts meaningful information from a route
  String _getRouteInfo(Route<dynamic>? route) {
    if (route == null) return 'none';

    final settings = route.settings;
    return settings.name ?? route.runtimeType.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigationEvent('PUSHED', current: route, previous: previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigationEvent('POPPED', current: previousRoute, previous: route);
  }
}
