/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:stake_pool_lotto/exceptions/exception.dart';
import 'package:stake_pool_lotto/programs/stake_pool/deposit.dart';
import 'package:stake_pool_lotto/programs/stake_pool/utils.dart';
import 'package:stake_pool_lotto/programs/stake_pool/withdraw.dart';
import 'package:stake_pool_lotto/providers/account_balance_provider.dart';
import 'package:stake_pool_lotto/widgets/components/section.dart';
import 'package:stake_pool_lotto/widgets/views/connect_view.dart';
import '../../exceptions/exception_handler.dart';
import '../../icons/dream_drops_icons.dart';
import '../../mixin/form_mixin.dart';
import '../../models/token.dart';
import '../../layouts/grid.dart';
import '../../providers/stake_provider.dart';
import '../scaffolds/screen_scaffold.dart';
import '../../themes/colors/color.dart';
import '../../widgets/buttons/icon_primary_button.dart';
import '../../widgets/components/logo.dart';
import '../../widgets/components/number_pad.dart';
import '../../widgets/components/solana_logo.dart';
import '../../widgets/tiles/token_tile.dart';
import '../../widgets/buttons/indicator_button.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/error_form_field.dart';


/// Swap Screen
/// ------------------------------------------------------------------------------------------------

class SPDSwapScreen extends StatefulWidget {

  const SPDSwapScreen({
    super.key,
  });

  static const String routeName = '/swap/swap';

  @override
  State<SPDSwapScreen> createState() => _SPDSwapScreenState();
}


/// Staking Screen State
/// ------------------------------------------------------------------------------------------------

class _SPDSwapScreenState extends State<SPDSwapScreen> with SPDFormMixin {

  bool _deposit = true;

  double _sendAmount = 0.0;
  String? _sendAmountLabel = '0';

  List<String> _titles = ['Send', 'Receive'];

  void _onChanged(final String? value) {
    double amount = 0.0;
    if (value != null) {
      final double? newAmount = double.tryParse(value);
      if (newAmount != null) {
        amount = newAmount;
      }
    }
    clearFormError();
    if (mounted && (_sendAmount != amount || value != _sendAmountLabel)) {
      setState(() {
        _sendAmount = amount;
        _sendAmountLabel = value;
      });
    }
  }

  @override
  FutureOr<String?> formValidator(final FormState state) async {
    try {
      final provider = SolanaWalletProvider.of(context);
      if (!provider.adapter.isAuthorized) {
        await provider.connect(context);
      }

      final BigInt amount = solToLamports(_sendAmount);
      if (amount == BigInt.zero) {
        throw SPDException('Invalid stake amount.');
      }

      await provider.signAndSendTransactionsWithSigners(
        context, 
        _deposit 
          ? deposit(provider: provider, amount: amount)
          : withdraw(provider: provider, amount: amount),
      );

      AccountBalanceProvider.shared.update(provider).ignore();
      if (!_deposit) StakeProvider.shared.update(provider).ignore();
      _onChanged('0');

      return null;
    } catch (error, stackTrace) {
      print('STACK $stackTrace');
      final String message = '${_deposit ? 'Deposit' : 'Withdrawal'} failed please try again soon.';
      return const SPDExceptionHandler().message(error, message);
    }
  }

  Widget _tokenTile({
    required final String title,
    required final double? amount,
    required final Widget icon,
    required final SPDToken token,
  }) {
    return SPDSection(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          GestureDetector(
            onTap: () {
              if (amount != null) {
                _onChanged(amount.toString());
              }
            },
            child: Text(
              '${amount ?? '-'} ${token.symbol}', 
              style: TextStyle(color: SPDColor.shared.secondary8),
            ),
          ),
        ],
      ),
      child: SPDTokenTile(
        icon: icon, 
        token: token, 
        amount: _sendAmount,
        amountLabel: _sendAmountLabel, 
      ),
    );
  }

  Widget _divider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          height: SPDGrid.x6,
        ),
        Positioned(
          child: SPDIconPrimaryButton(
            icon: SPDIcons.reverse,
            onPressed: () {
              _titles = _titles.reversed.toList(growable: false);
              setState(() => _deposit = !_deposit);
            },
          ),
        ),
      ],
    );
  }

  Widget _builder(
    final BuildContext context,
    final AccountBalanceProvider accountBalanceProvider,
    final Widget? child,
  ) {
    final provider = SolanaWalletProvider.of(context);
    final account = provider.connectedAccount;
    final solanaTile = _tokenTile(
      title: _titles[0], 
      amount: account != null ? accountBalanceProvider.sol : null, 
      icon: SPDSolanaLogo(), 
      token: SPDToken.solana,
    );
    final tokenTile = _tokenTile(
      title: _titles[1], 
      amount: account != null ? accountBalanceProvider.token : null, 
      icon: SPDLogo(), 
      token: SPDToken.drop,
    );
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _deposit ? solanaTile : tokenTile,
          _divider(),
          _deposit ? tokenTile : solanaTile,
        ],
      ),
    );
  }

  Widget _buildForm(final BuildContext context, final Account account) {
    final Color color = _deposit 
      ? SPDColor.shared.brand 
      : SPDColor.shared.error;
    return Form(
      key: formKey,
      child: Column(
        // spacing: 0.0,//SPDGrid.x3,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: SPDGrid.x2,
          ),
          Expanded(
            child: Consumer<AccountBalanceProvider>(
              builder: _builder,
            ),
          ),
          SPDErrorFormField(
            error: formSubmitError,
            padding: EdgeInsets.only(
              top: SPDGrid.x2,
            ),
          ),
          const SizedBox(
            height: SPDGrid.x2,
          ),
          SizedBox(
            height: 320 + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SPDNumberPad(
                  enabled: isFormEnabled,
                  onChanged: _onChanged,
                  value: _sendAmountLabel,
                ),
                const SizedBox(
                  height: SPDGrid.x2,
                ),
                SPDIndicatorButton(
                  onPressed: onFormSubmit,
                  enabled: isFormEnabled && _sendAmount != 0.0,
                  showIndicator: isFormSubmitting,
                  expand: true,
                  style: SPDPrimaryButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: Text(_deposit ? 'Stake' : 'Unstake'), 
                ),
                const SizedBox(
                  height: SPDGrid.x2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SPDScreenScaffold(
      title: 'Swap', 
      child: SPDConnectView(
        message: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Stake with '),
              TextSpan(text: SPDToken.drop.name, style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' for a chance to win.')
            ]
          ),
        ),
        builder: _buildForm,
      ),
    );
  }
}