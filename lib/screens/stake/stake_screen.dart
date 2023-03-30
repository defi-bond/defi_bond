/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../../constants.dart';
import '../../layouts/grid.dart';
import '../../programs/stake_pool/deposit.dart';
import '../../providers/account_balance_provider.dart';
import '../../providers/stake_provider.dart';
import '../../screens/scaffolds/screen_scaffold.dart';
import '../../widgets/cards/stake_card.dart';
import '../../widgets/components/section.dart';
import '../../widgets/indicators/circular_progress_indicator.dart';
import '../../widgets/tiles/stake_tile.dart';
import '../../widgets/views/connect_view.dart';
import '../../widgets/views/stack_view.dart';


/// Stake Screen
/// ------------------------------------------------------------------------------------------------

class SPDStakeScreen extends StatefulWidget {
  
  const SPDStakeScreen({
    super.key,
  });

  static const String routeName = '/stake/stake';

  @override
  State<SPDStakeScreen> createState() => _SPDStakeScreenState();
}


/// Stake Screen State
/// ------------------------------------------------------------------------------------------------

class _SPDStakeScreenState extends State<SPDStakeScreen> {

  Future<void> _onRefresh() {
    final provider = SolanaWalletProvider.of(context);
    return StakeProvider.shared.update(provider);
  }

  void _onTapAccount(final DelegationInfo info) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SPDStakeCard(
        info: info,
        onDeactivate: _onTapDeactivate,  
        onDelegate: _onTapDelegate,
        onWithdraw: _onTapWithdraw,
      ),
    );
  }

  void _popModal() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _onTapDeactivate(final DelegationInfo info) async {
    _popModal();
    final provider = SolanaWalletProvider.of(context);
    final connectedAccount = provider.connectedAccount?.toPublicKey();
    if (connectedAccount != null) {
      await provider.signAndSendTransactions(
        context, 
        Future.value([
          Transaction(
            instructions: [
              StakeProgram.deactivate(
                stakeAccount: PublicKey.fromBase58(info.address), 
                authority: connectedAccount,
              ),
            ],
          ),
        ]),
      );
      StakeProvider.shared.update(provider).ignore();
    }
  }

  void _onTapDelegate(final DelegationInfo info) async {
    _popModal();
    final provider = SolanaWalletProvider.of(context);
    final connectedAccount = provider.connectedAccount?.toPublicKey();
    if (connectedAccount != null) {
      print('ADDR ${PublicKey.fromBase58(info.address)}');
      print('VOTE ${PublicKey.fromBase58(info.vote)}');
      await provider.signAndSendTransactionsWithSigners(
        context, 
        deposit(
          provider: provider, 
          stakeAccount: PublicKey.fromBase58(info.address),
          validatorStakeAccount: StakePoolProgram.findStakeProgramAddress(
            PublicKey.fromBase58(info.vote), 
            stakePoolAddress,
          ).publicKey,
        ),
      );
      StakeProvider.shared.update(provider).ignore();
    }
  }

  void _onTapWithdraw(final DelegationInfo info) async {
    _popModal();
    final provider = SolanaWalletProvider.of(context);
    final connectedAccount = provider.connectedAccount?.toPublicKey();
    if (connectedAccount != null) {
      await provider.signAndSendTransactions(
        context, 
        Future.value([
          Transaction(
            instructions: [
              StakeProgram.withdraw(
                stakeAccount: PublicKey.fromBase58(info.address), 
                recipientAccount: connectedAccount,
                withdrawAuthority: connectedAccount,
                lamports: solToLamports(info.stake) + solToLamports(info.rent),
              ),
            ],
          ),
        ]),
      );
      StakeProvider.shared.update(provider).ignore();
    }
  }

  Widget _listBuilder(
    final BuildContext context, 
    final StakeProvider stakeProvider, 
    final Widget? child,
  ) {
    final List<DelegationInfo>? stakeAccounts = stakeProvider.accounts;
    if (stakeAccounts == null) {
      return stakeProvider.isUpdating
        ? SPDStackView(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SPDCircularProgressIndicator(),
              Text('Searching for stake accounts.'),
            ],
          )
        : SPDStackView(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: SPDGrid.x1,),
              Image.asset('assets/images/error.png', width: 200),
              Text('Unable to load stake accounts.'),
            ],
          );
    }

    if (stakeAccounts.isEmpty) {
      return SPDStackView(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: SPDGrid.x1,),
          Image.asset('assets/images/empty.png', width: 200),
          Text('No stake accounts available.'),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: stakeAccounts.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => SPDStakeTile(index: i, info: stakeAccounts[i], onTap: _onTapAccount),
      separatorBuilder: (_, i) => SizedBox(height: SPDGrid.x2),
    );
  }

  Widget _builder(final BuildContext context, final Account account) {
    final double? tokenBalance = AccountBalanceProvider.shared.token;
    return SPDStackView(
      mainAxisSize: MainAxisSize.max,
      spacing: SPDGrid.x4,
      children: [
        if (tokenBalance != null)
          SPDSection(
            title: Text('Stake Pools'), 
            child: SPDStakeTile(
              index: 0, 
              info: DelegationInfo(
                address: stakePoolAddress.toBase58(), 
                vote: 'DDT', 
                stake: tokenBalance, 
                rent: 0.0, 
                credits: 0.0, 
                status: DelegationStatus.active, 
                deactivationEpoch: BigInt.zero,
              ),
            ),
          ),
          SPDSection(
            title: Text('Stake Accounts'), 
            child: Consumer<StakeProvider>(
              builder: _listBuilder,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SPDScreenScaffold(
      title: 'Stake',
      hasScrollBody: true,
      onRefresh: _onRefresh,
      child: SPDConnectView(
        message: Text('Manage your stake accounts.'),
        builder: _builder,
      ),
    );
  }
}