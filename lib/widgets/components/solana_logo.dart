/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/grid.dart';
import '../../icons/dream_drops_icons.dart';


/// Solana Logo
/// ------------------------------------------------------------------------------------------------

class SPDSolanaLogo extends StatelessWidget {
  
  const SPDSolanaLogo({
    super.key,
    this.size = SPDGrid.x3,
  });

  final double? size;

  Shader _shaderCallback(final Rect rect) 
    => LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: const [
        Color(0xFF9945FF),
        Color(0xFF14F195),
      ],
    ).createShader(
      rect,
    );

  @override
  Widget build(final BuildContext context) => ShaderMask(
    shaderCallback: _shaderCallback,
    child: Icon(
      SPDIcons.solana,
      size: size,
    ),
  );
}