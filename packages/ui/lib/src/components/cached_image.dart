import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:ui/ui.dart';

/// A widget that displays an image from a URL.
class AksCachedImage extends StatelessWidget {
  /// Creates a widget that displays an image from a URL.
  const AksCachedImage({
    /// The URL of the image to display.
    required this.imageUrl,

    /// The custom image provider to use instead of the default CachedNetworkImageProvider.
    this.cachedImageProvider,

    /// A builder that specifies the widget to display the image.
    this.imageBuilder,

    /// Widget to display when an error occurs while loading the image.
    this.errorImage,

    /// A builder that specifies the placeholder widget while the image is loading.
    this.placeholderBuilder,

    /// A builder that specifies a progress indicator while the image is loading.
    this.progressIndicatorBuilder,

    /// A builder that specifies the widget to display when an error occurs.
    this.errorBuilder,

    /// The width of the widget.
    this.width,

    /// The height of the widget.
    this.height,

    /// The filter quality of the image.
    this.filterQuality = FilterQuality.medium,

    /// How the image should be inscribed into the space allocated during layout.
    this.fit,

    /// Whether to continue showing the old image when the image provider changes.
    this.gaplessPlayback = false,

    /// The color to blend with the image using BlendMode.srcIn.
    this.color,
    super.key,
  });

  /// The URL of the image to display.
  final String? imageUrl;

  /// The image provider to use.
  final CachedNetworkImageProvider? cachedImageProvider;

  /// If provided, the image will be displayed in a widget created by this builder.
  final OctoImageBuilder? imageBuilder;

  /// Widget to display when an error occurs while loading the image.
  final Widget? errorImage;

  /// If provided, this widget will be displayed while the image is loading.
  final OctoPlaceholderBuilder? placeholderBuilder;

  /// If provided, this widget will be displayed while the image is loading.
  final OctoProgressIndicatorBuilder? progressIndicatorBuilder;

  /// If provided, this widget will be displayed if the image fails to load.
  final OctoErrorBuilder? errorBuilder;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// The filter quality of the image.
  final FilterQuality? filterQuality;

  /// The box fit of the image.
  final BoxFit? fit;

  /// Whether to use gapless playback.
  final bool gaplessPlayback;

  /// The color of the image.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      width: width,
      height: height,
      image: cachedImageProvider ?? CachedNetworkImageProvider(imageUrl ?? ''),
      imageBuilder: imageBuilder,
      placeholderBuilder: placeholderBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorBuilder: errorBuilder ?? (context, _, __) => errorImage ?? Space.empty,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      fit: fit,
      color: color,
    );
  }
}
