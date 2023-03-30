/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../buttons/primary_button.dart';
import '../../extensions/text_style.dart';
import '../../layouts/grid.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../../widgets/animations/fade_and_scale_switcher.dart';


/// Connect View
/// ------------------------------------------------------------------------------------------------

class SPDConnectView extends StatelessWidget {
  
  const SPDConnectView({
    super.key, 
    required this.builder,
    this.message,
  });

  final Widget Function(BuildContext context, Account account) builder;

  final Widget? message;

  @override
  Widget build(final BuildContext context) {
    final SolanaWalletProvider provider = SolanaWalletProvider.of(context);
    final Account? connectedAccount = provider.connectedAccount;
    final Widget? message = this.message;
    return SPDFadeAndScaleSwitcher(
      child: connectedAccount != null
        ? builder(
            context, connectedAccount, 
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: SPDGrid.x3,
                  ),
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: SPDFont.shared.bodyMedium.setColor(SPDColor.shared.secondary8),
                    child: message,
                  ),
                ),
              SolanaWalletButton(
                disconnectedStyle: SPDPrimaryButton.styleFrom(),
              ),
            ],
          ),
    );
  }
}