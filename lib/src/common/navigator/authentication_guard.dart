import 'package:flutter/material.dart';
import 'package:smartpay/src/common/navigator/routes.dart';
import 'package:smartpay/src/feature/authentication/model/user.dart';

/// A router guard that checks if the user is authenticated.
final class AuthenticationGuard {
  AuthenticationGuard({
    required User Function() getUser,
    required Set<Routes> authRoutes,
    required Routes defaultAuthRoute,
    required Routes defaultHomeRoute,
  }) : _getUser = getUser,
       _authRoutes = authRoutes,
       _defaultAuthRoute = defaultAuthRoute,
       _defaultHomeRoute = defaultHomeRoute;

  /// Get the current user.
  final User Function() _getUser;

  /// Routes that stand for the authentication routes.
  final Set<Routes> _authRoutes;

  /// The default route to use when the user is not authenticated.
  final Routes _defaultAuthRoute;

  /// The default route to use when the user is authenticated.
  final Routes _defaultHomeRoute;

  /// The last authenticated navigation state.
  List<Page<Object?>> _lastAuthenticatedPages = [];

  /// Apply the guard to the given pages.
  List<Page<Object?>> call(List<Page<Object?>> pages) {
    final user = _getUser();

    // Check if the current navigation is an authentication navigation
    final isAuthNav = pages.any((page) => _authRoutes.any((route) => route.name == page.name));

    if (isAuthNav) {
      // Current navigation is an authentication navigation
      if (user.isAuthenticated) {
        // User is authenticated, remove auth pages
        final filteredPages = pages.where((page) => !_authRoutes.any((route) => route.name == page.name)).toList();

        // If no pages left, restore last authenticated pages or go to home
        if (filteredPages.isEmpty) {
          return _lastAuthenticatedPages.isNotEmpty ? _lastAuthenticatedPages : [_defaultHomeRoute.page()];
        }
        return filteredPages;
      } else {
        // User is not authenticated, keep only auth pages
        final filteredPages = pages.where((page) => _authRoutes.any((route) => route.name == page.name)).toList();

        // If no pages left, go to default auth route
        if (filteredPages.isEmpty) {
          return [_defaultAuthRoute.page()];
        }
        return filteredPages;
      }
    } else {
      // Current navigation is not an authentication navigation
      if (user.isAuthenticated) {
        // User is authenticated, save current pages as last authenticated
        _lastAuthenticatedPages = List.of(pages);
        return pages;
      } else {
        // User is not authenticated, redirect to auth
        return [_defaultAuthRoute.page()];
      }
    }
  }
}
