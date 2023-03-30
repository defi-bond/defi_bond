/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../navigator/navigator.dart';
import '../../routes/route_arguments.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../scaffolds/screen_scaffold.dart';
import '../../widgets/buttons/icon_secondary_button.dart';
import '../../widgets/components/section.dart';
import '../../widgets/tiles/list_tile.dart';
import '../../widgets/views/stack_view.dart';
import 'faqs_screen.dart';


/// Account Screen
/// ------------------------------------------------------------------------------------------------

class SPDDiscoverScreen extends StatefulWidget {
  
  const SPDDiscoverScreen({ 
    super.key,
  });

  /// Navigator route name.
  static const String routeName = '/discover/discover';

  /// Serialise this class into a json object.
  Map<String, dynamic> toJson() => {};

  /// Create an instance of this class from the given json object.
  /// @param [json]: A map containing the class' constructor parameters.
  factory SPDDiscoverScreen.fromJson(Map<String, dynamic> json)
    => const SPDDiscoverScreen();

  /// Create an instance of the class' state widget.
  @override
  SPDDiscoverScreenState createState() => SPDDiscoverScreenState();
}


/// Account Screen State
/// ------------------------------------------------------------------------------------------------

class SPDDiscoverScreenState extends State<SPDDiscoverScreen> {

  Future<PackageInfo>? _packageInfo;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
  }

  Widget _placeholderIconButton(final IconData icon) => IgnorePointer(
    child: SPDIconSecondaryButton(icon: icon, onPressed: () => null),
  );

  void _onTapFAQs() {
    SPDNavigator.shared.pushNamed(
      context, 
      SPDFAQsScreen.routeName,
      arguments: SPDRouteArguments(checkpoint: false),
    ).ignore();
  }

  Widget _appInfoBuilder(
    final BuildContext context, 
    final AsyncSnapshot<PackageInfo> snapshot,
  ) {
    final PackageInfo? packageInfo = snapshot.data;
    return SPDStackView(
      children: [
        SPDListTile(
          title: Text('Version'),
          titleTrailing: Text(packageInfo != null
            ? packageInfo.version
            : '-'),
        ),
        SPDListTile(
          title: Text('Build Number'),
          titleTrailing: Text(packageInfo != null
            ? packageInfo.buildNumber
            : '-'),
        ),
      ],
    );
  }

  /// Build the final widget.
  @override
  Widget build(final BuildContext context) {    
    return SPDScreenScaffold(
      title: 'Discover', 
      child: Padding(
        padding: SPDEdgeInsets.shared.vertical(),
        child: SPDStackView(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: SPDGrid.x6,
          children: [
            SPDSection(
              title: Text('Help'), 
              child: SPDListTile(
                title: Text('FAQs'),
                titleTrailing: _placeholderIconButton(SPDIcons.arrowright),
                onTap: _onTapFAQs,
              ),
            ),
            SPDSection(
              title: Text('Contact'), 
              child: SPDStackView(
                children: [
                  SPDListTile(
                    title: Text('Twitter'),
                    titleTrailing: _placeholderIconButton(SPDIcons.arrowlink),
                    onTap: () => launchUrlString(
                      'https://twitter.com/StakePoolDrops',
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
              ),
            ),
            SPDSection(
              title: Text('App Info'), 
              child: FutureBuilder(
                future: _packageInfo,
                builder: _appInfoBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}