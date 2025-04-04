import 'package:flutter/material.dart';

/// A utility class that provides predefined spacing widgets.
///
/// This class contains static constant widgets for common vertical and horizontal
/// spacing needs in the UI. All measurements are in logical pixels.
final class Space {
  /// Private constructor to prevent instantiation
  const Space._();

  /// A zero-sized box that takes up no space
  static const empty = SizedBox.shrink();

  /// Vertical space of 5 logical pixels
  static const v5 = SizedBox(height: 5);

  /// Vertical space of 10 logical pixels
  static const v10 = SizedBox(height: 10);

  /// Vertical space of 15 logical pixels
  static const v15 = SizedBox(height: 15);

  /// Vertical space of 20 logical pixels
  static const v20 = SizedBox(height: 20);

  /// Vertical space of 25 logical pixels
  static const v25 = SizedBox(height: 25);

  /// Horizontal space of 5 logical pixels
  static const h5 = SizedBox(width: 5);

  /// Horizontal space of 10 logical pixels
  static const h10 = SizedBox(width: 10);

  /// Horizontal space of 15 logical pixels
  static const h15 = SizedBox(width: 15);

  /// Horizontal space of 20 logical pixels
  static const h20 = SizedBox(width: 20);

  /// Horizontal space of 25 logical pixels
  static const h25 = SizedBox(width: 25);
}
