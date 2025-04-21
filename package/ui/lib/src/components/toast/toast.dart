import 'package:flutter/material.dart';

enum ToastAnimationType { fade, slideUp, scale }

class Toast extends InheritedWidget {
  const Toast({required super.child, super.key});

  static Toast of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Toast>();
    assert(result != null, 'No Toast found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(Toast oldWidget) => child != oldWidget.child;

  static OverlayEntry show({
    required BuildContext context,
    required Widget child,
    Duration duration = const Duration(seconds: 3),
    ToastAnimationType animationType = ToastAnimationType.fade,
    Curve curve = Curves.easeInOut,
    double bottomMargin = 32,
  }) {
    late final OverlayEntry overlayEntry;

    var animatedChild = child;

    switch (animationType) {
      case ToastAnimationType.fade:
        animatedChild = TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: curve,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(opacity: value, child: child!),
          child: child,
        );
        break;
      case ToastAnimationType.slideUp:
        animatedChild = TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: curve,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) => Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child!),
          child: child,
        );
        break;
      case ToastAnimationType.scale:
        animatedChild = TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: curve,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) => Transform.scale(scale: value, child: child!),
          child: child,
        );
        break;
    }

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: 16,
            right: 16,
            bottom: bottomMargin,
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) => overlayEntry.remove(),
              child: animatedChild,
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration - const Duration(milliseconds: 300), () {
      if (overlayEntry.mounted) {
        overlayEntry.markNeedsBuild();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        });
      }
    });

    return overlayEntry;
  }

  /// Shows a success toast with predefined styling
  static OverlayEntry showSuccess(
    BuildContext context, {
    required String message,
    Duration? duration,
    double bottomMargin = 32,
  }) => show(
    context: context,
    duration: duration ?? const Duration(seconds: 3),
    animationType: ToastAnimationType.slideUp,
    bottomMargin: bottomMargin, // Pass the parameter
    child: Card(
      color: ColorScheme.of(context).primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          message,
          style: TextTheme.of(context).labelLarge?.copyWith(color: ColorScheme.of(context).onPrimary),
        ),
      ),
    ),
  );

  /// Shows an error toast with predefined styling
  static OverlayEntry showError(
    BuildContext context, {
    required String message,
    Duration? duration,
    double bottomMargin = 32,
  }) => show(
    context: context,
    duration: duration ?? const Duration(seconds: 3),
    animationType: ToastAnimationType.slideUp,
    bottomMargin: bottomMargin,
    child: Card(
      color: ColorScheme.of(context).error,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          message,
          style: TextTheme.of(context).labelLarge?.copyWith(color: ColorScheme.of(context).onPrimary),
        ),
      ),
    ),
  );
}
