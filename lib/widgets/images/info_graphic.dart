/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../assets/asset_image.dart';
import '../../assets/asset_image_id.dart';
import '../../exceptions/exception_handler.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../../widgets/indicators/circular_progress_indicator.dart';
import '../views/stack_view.dart';


/// Info Graphic
/// ------------------------------------------------------------------------------------------------

class SPDInfoGraphic extends StatelessWidget {
  
  /// Creates an info graphic for asset [id].
  const SPDInfoGraphic({ 
    Key? key, 
    required this.id,
    this.title,
    this.description,
    this.actions,
  }): super(key: key);

  /// Creates an [SPDInfoGraphic] for the asset identifier [SPDAssetImageID.empty].
  /// @param [title]: The title text (default: `No results`).
  /// @param [description]: The description text.
  /// @param [action]: The actions.
  factory SPDInfoGraphic.empty({ 
    String? title, 
    String? description, 
    List<Widget>? actions,
  }) {
    return SPDInfoGraphic(
      id: SPDAssetImageID.empty,
      title: title ?? 'No results',
      description: description ?? 'Nothing to see here.',
      actions: actions,
    );
  }

  /// Creates an [SPDInfoGraphic] for the asset identifier [SPDAssetImageID.error].
  /// @param [error]: The error to parse for a [description].
  /// @param [title]: The title text (default: `Oh no!`).
  /// @param [description]: The description used if [error] does not contain a message (default: 
  /// `[OAExceptionHandler.fallbackDefaultMessage]`).
  /// @param [action]: The actions.
  factory SPDInfoGraphic.error({ 
    Object? error, 
    String? title, 
    String? description, 
    List<Widget>? actions,
  }) {
    return SPDInfoGraphic(
      id: SPDAssetImageID.error,
      title: title ?? 'Oh no!',
      description: const SPDExceptionHandler().message(error, description),
      actions: actions,
    );
  }

  /// The asset's identifier.
  final SPDAssetImageID id;

  /// The title text.
  final String? title;

  /// The description text.
  final String? description;

  /// The actions.
  final List<Widget>? actions;

  /// Return the image's natural width (216) and height (120).
  Size get _imageSize {
    return const Size(SPDGrid.x1 * 27, SPDGrid.x1 * 15);
  }

  /// Return the text area's (title/description) maximum width (320).
  double get _textWidth {
    return SPDGrid.x1 * 40;
  }

  /// Return the SVG image file path for the file named `ig_[name].svg`.
  /// @param [part*]: The file name segments.
  String _imagePath(final String name) {
    return SPDAssetImage.shared.path(['ig_$name.svg']);
  }

  /// Build the first layer of the SVG image (background).
  Widget _buildLayer0() {
    return SvgPicture.asset(
      _imagePath('background'),
      color: SPDColor.shared.primary2,
    );
  }

  /// Build the second layer of the SVG image (background drawing).
  Widget _buildLayer1() {
    return SvgPicture.asset(
      _imagePath('${id.name}_background'),
      color: SPDColor.shared.brand1,
    );
  }

  /// Build the third layer of the SVG image (foreground drawing).
  Widget _buildLayer2() {
    return SvgPicture.asset(
      _imagePath('${id.name}_foreground'),
      color: SPDColor.shared.secondary1,
      placeholderBuilder: (_) => const SPDCircularProgressIndicator(),
    );
  }

  /// Wrap [child] in a [ConstrainedBox] widget with a maximum width.
  /// @param [child]: The widget to constrain the width of.
  /// @param [maxWidth]: The [child] widget's maximum width.
  Widget _constrainedBox({ required Widget child, required double maxWidth }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      child: child,
    );
  }

  /// Build the final widget.
  /// @param [context]: The current build context.
  @override
  Widget build(BuildContext context) {
    return SPLStackView(
      axis: Axis.vertical,
      isScrollable: false,
      mainAxisSize: MainAxisSize.min,
      children: [
        _constrainedBox(
          child: AspectRatio(
            aspectRatio: _imageSize.aspectRatio,
            child: Stack(
              children: [
                _buildLayer0(),
                _buildLayer1(),
                _buildLayer2(),
              ],
            ),
          ), 
          maxWidth: _imageSize.width,
        ),
    
        if (title != null)
          _constrainedBox(
            child: Text(
              title!, 
              textAlign: TextAlign.center,
              style: SPDFont.shared.headline3,
            ), 
            maxWidth: _textWidth, 
          ),
        
        if (description != null)
          _constrainedBox(
            child: Text(
              description!, 
              textAlign: TextAlign.center,
              style: SPDFont.shared.body2.setColor(SPDColor.shared.watermark),
            ),
            maxWidth: _textWidth,
          ),
    
        if (actions != null && actions!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: SPDGrid.x1,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: SPDGrid.x2,
              runSpacing: SPDGrid.x2,
              children: actions!
            ),
          ),
      ],
    );
  }
}