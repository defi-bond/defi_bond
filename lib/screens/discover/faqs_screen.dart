/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/grid.dart';
import 'package:stake_pool_lotto/widgets/buttons/secondary_button.dart';
import 'package:stake_pool_lotto/widgets/views/stack_view.dart';
import '../../constants.dart';
import '../../icons/dream_drops_icons.dart';
import '../scaffolds/screen_scaffold.dart';
import '../../widgets/tiles/list_tile.dart';
import '../../widgets/buttons/icon_secondary_button.dart';


/// FAQs Screen
/// ------------------------------------------------------------------------------------------------

class SPDFAQsScreen extends StatelessWidget {
  
  const SPDFAQsScreen({
    super.key,
  });

  static const String routeName = '/account/faqs';

  @override
  Widget build(final BuildContext context) {
    return SPDScreenScaffold(
      title: 'FAQs', 
      canPop: true,
      child: SPDStackView(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Coming Soon')
          // _SPDQuestionAndAnswer(
          //   question: 'How to Play?', 
          //   answer: 'Stake your SOL for a chance to win.',
          // ),
        ],
      ),
    );
  }
}


/// Q&A
/// ------------------------------------------------------------------------------------------------

class _SPDQuestionAndAnswer extends StatefulWidget {
  
  const _SPDQuestionAndAnswer({
    required this.question,
    required this.answer,
  });

  final String question;

  final String answer;

  @override
  State<_SPDQuestionAndAnswer> createState() => __SPDQuestionAndAnswerState();
}


/// Q&A State
/// ------------------------------------------------------------------------------------------------

class __SPDQuestionAndAnswerState extends State<_SPDQuestionAndAnswer> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _placeholderIconButton(final IconData icon) => IgnorePointer(
    child: SPDIconSecondaryButton(icon: icon, onPressed: () => null),
  );

  _onTap() {
    _controller.value > 0.5 ? _controller.reverse() : _controller.forward();
  }

  Widget _builder(
    final BuildContext context,
    final Widget? child,
  ) {
    return Column(
      children: [
        SPDListTile(
          title: Text(widget.question),
          titleTrailing: IgnorePointer(
            child: TextButton(
              style: SPDSecondaryButton.styleFrom(),
              onPressed: () => null,
              child: Transform.scale(
                scaleY: 1 - (_controller.value * 2.0),
                child: Icon(SPDIcons.chevrondown),
              ),
            ),
          ),
          onTap: _onTap,
        ),
        FadeTransition(
          opacity: _controller,
          child: SizeTransition(
            sizeFactor: _controller,
            child: Padding(
              padding: const EdgeInsets.only(
                top: SPDGrid.x1,
              ),
              child: Text(widget.answer),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: _builder,
      child: _placeholderIconButton(SPDIcons.chevrondown),
    );
  }
}