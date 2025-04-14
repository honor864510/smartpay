import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => TextTheme.of(this);

  // Size
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;
}
