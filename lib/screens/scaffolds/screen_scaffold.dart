/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/themes/colors/color.dart';
import '../../widgets/bars/app_bar.dart';


/// Screen Scaffold
/// ------------------------------------------------------------------------------------------------

class SPDScreenScaffold extends StatelessWidget {

  const SPDScreenScaffold({
    super.key,
    this.title,
    this.canPop = false,
    required this.child,
    this.onRefresh,
    this.hasScrollBody = false,
  });

  final String? title;

  final bool canPop;

  final Widget child;

  final RefreshCallback? onRefresh;

  final bool hasScrollBody;

  @override
  Widget build(final BuildContext context) {

    PreferredSizeWidget? screenTitle;
    final String? title = this.title;
    if (title != null) {
      screenTitle = SPDAppBar(
        title: Text(title),
        canPop: canPop,
      );
    }
    
    Widget screenContent = CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        hasScrollBody
          ? SliverToBoxAdapter(
            child: child,
          )
        : SliverFillRemaining(
            hasScrollBody: false,
            child: child,
          ),
      ],
    );

    final RefreshCallback? onRefresh = this.onRefresh;
    if (onRefresh != null) {
      screenContent = RefreshIndicator(
        color: SPDColor.shared.brand,
        onRefresh: onRefresh,
        child: screenContent, 
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: screenTitle,
        body: screenContent,
      ),
    );
  }
}