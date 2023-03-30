/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../exceptions/exception.dart';
import '../../exceptions/exception_handler.dart';
import '../../icons/dream_drops_icons.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../mixin/form_mixin.dart';
import '../../models/token.dart';
import '../../providers/account_balance_provider.dart';
import '../scaffolds/screen_scaffold.dart';
import '../../themes/colors/color.dart';
import '../../themes/fonts/font.dart';
import '../../utils/format.dart';
import '../../widgets/buttons/icon_primary_button.dart';
import '../../widgets/buttons/indicator_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/tertiary_button.dart';
import '../../widgets/forms/error_form_field.dart';
import '../../widgets/forms/text_form_field.dart';


/// Staking Screen
/// ------------------------------------------------------------------------------------------------

class _SPDStakingScreen extends StatefulWidget {
  
  const _SPDStakingScreen({
    super.key,
  });

  static const String routeName = '/staking/staking';

  @override
  State<_SPDStakingScreen> createState() => __SPDStakingScreenState();
}


/// Staking Screen State
/// ------------------------------------------------------------------------------------------------

class __SPDStakingScreenState extends State<_SPDStakingScreen> with SPDFormMixin {
  
  // Form field's focus node.
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _textEditingController = TextEditingController();

  // Deposit or withdraw.
  bool _deposit = true;

  // Input amount.
  BigInt? _amount;

  bool _hasAmount = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPressedMax(final double? amount) {
    if (amount != null) {
      final String text = '$amount';
      _textEditingController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  void _onSaved(final String? value) {
    if (value != null) {
      final double? amount = double.tryParse(value);
      if (amount != null) {
        _amount = solToLamports(amount);
      }
    }
  }

  void _onChanged(final String? value) {
    bool hasAmount = _hasAmount;
    if (value != null) {
      final double? amount = double.tryParse(value);
      hasAmount = amount != null && amount > 0.0;
    } else {
      hasAmount = false;
    }
    if (mounted && _hasAmount != hasAmount) setState(() { _hasAmount = hasAmount; });
  }

  @override
  FutureOr<String?> formValidator(final FormState state) async {
    try {
      // Check the input value.
      final BigInt? amount = _amount;
      if (amount == null) {
        throw const SPDException('Invalid amount.');
      }

      // Get the wallet provider.
      final provider = SolanaWalletProvider.of(context);

      // Authorize the wallet with the app.
      if (!provider.adapter.isAuthorized) {
        await provider.connect(context);
      }
      
      // await depositOrWithdraw(
      //   context,
      //   provider: provider, 
      //   amount: _deposit ? amount : -amount,
      // );

      AccountBalanceProvider.shared.update(provider).ignore();

      return null;

    } catch (error, stackTrace) {
      print('STACK $stackTrace');
      final String message = '${_deposit ? 'Deposit' : 'Withdrawal'} failed please try again soon.';
      return const SPDExceptionHandler().message(error, message);
    }
  }

  void _onReverse() {
    setState(() => _deposit = !_deposit);
    clearFormError();
  }

  Widget _buildAccount({
    required final String title,
    required final SPDToken token,
    required final TextAlign textAlign,
    required final double? amount,
  }) {
    final String balance = amount != null ? formatNumber(amount) : '-';
    return Tooltip(
      message: '${token.symbol} $amount',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: textAlign == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: textAlign,
            style: SPDFont.shared.medium(16.0),
          ),
          const SizedBox(
            height: SPDGrid.x2,
          ),
          Text(
            token.name,
            textAlign: textAlign,
            style: SPDFont.shared.medium(18.0),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(
            '$balance ${token.symbol}',
            textAlign: textAlign,
            style: SPDFont.shared.style(16.0, color: SPDColor.shared.secondary8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {

    // Token balances (SOL and SPLT).
    final AccountBalanceProvider accountBalanceProvider = context.watch<AccountBalanceProvider>();

    // Styling
    late final Color color;
    late final SPDToken send;
    late final double? sendBalance;
    late final SPDToken receive;
    late final double? receiveBalance;

    // Set style based on deposit type.
    if (_deposit) {
      color = SPDColor.shared.success;
      send = SPDToken.solana;
      sendBalance = accountBalanceProvider.sol;
      receive = SPDToken.drop;
      receiveBalance = accountBalanceProvider.token;
    } else {
      color = SPDColor.shared.error;
      send = SPDToken.drop;
      sendBalance = accountBalanceProvider.token;
      receive = SPDToken.solana;
      receiveBalance = accountBalanceProvider.sol;
    }

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: SPDScreenScaffold(
        title: 'Staking',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildAccount(
                          title: 'Send', 
                          token: send, 
                          textAlign: TextAlign.left,
                          amount: sendBalance,
                        ),
                      ),
                      Padding(
                        padding: SPDEdgeInsets.shared.horizontal(
                          SPDGrid.x2,
                        ),
                        child: SizedBox(
                          height: SPDGrid.x6,
                          child: SPDIconPrimaryButton(
                            icon: SPDIcons.reverse, 
                            iconSize: SPDGrid.x2,
                            onPressed: _onReverse,
                            // backgroundColor: color,
                            enabled: isFormEnabled,
                            style: SPDPrimaryButton.styleFrom(
                              backgroundColor: color,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildAccount(
                          title: 'Receive', 
                          token: receive,
                          textAlign: TextAlign.right,
                          amount: receiveBalance,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: SPDGrid.x4,
            ),
            Form(
              key: formKey,
              onChanged: clearFormError,
              child: Column(
                children: [
                  SPDTextFormField(
                    controller: _textEditingController,
                    autofocus: true,
                    focusNode: _focusNode,
                    onSaved: _onSaved,
                    onChanged: _onChanged,
                    enabled: isFormEnabled,
                    decoration: InputDecoration(
                      hintText: '0.0',
                      prefixIcon: Icon(
                        SPDIcons.solana,
                        color: SPDColor.shared.secondary1,
                      ),
                      suffixIcon: SizedBox(
                        height: 12,
                        child: SPDTertiaryButton(
                          onPressed: () => _onPressedMax(sendBalance),
                          style: SPDTertiaryButton.styleFrom(
                            padding: SPDEdgeInsets.shared.horizontal(SPDGrid.x2),
                            color: color,
                          ),
                          child: const Text('Max'), 
                        ),
                      ),
                    ),
                    
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    
                  ),
                  SPDErrorFormField(
                    error: formSubmitError,
                    padding: const EdgeInsets.only(top: SPDGrid.x2),
                  ),
                  const SizedBox(
                    height: SPDGrid.x2,
                  ),
                  SPDIndicatorButton(
                    onPressed: onFormSubmit,
                    enabled: isFormEnabled && _hasAmount,
                    showIndicator: isFormSubmitting,
                    expand: true,
                    style: SPDPrimaryButton.styleFrom(
                      backgroundColor: color, 
                    ),
                    child: Text(_deposit ? 'Stake' : 'Unstake'), 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}