/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import '../buttons/primary_button.dart';
import '../../layouts/grid.dart';
import '../../layouts/padding.dart';
import '../../models/token.dart';
import '../../providers/stake_provider.dart';
import '../../themes/colors/color.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/indicators/circular_progress_indicator.dart';
import '../../widgets/views/stack_view.dart';


/// Stake Card
/// ------------------------------------------------------------------------------------------------

class SPDStakeCard extends StatelessWidget {

  const SPDStakeCard({
    super.key,
    required this.info,
    required this.onDeactivate,
    required this.onDelegate,
    required this.onWithdraw,
  });

  final DelegationInfo info;

  final void Function(DelegationInfo info) onDeactivate;

  final void Function(DelegationInfo info) onDelegate;

  final void Function(DelegationInfo info) onWithdraw;

  _SPDStakeCardData _data(final Color color) {
    switch (info.status) {
      case DelegationStatus.active:
        return _SPDStakeCardData(
          Text.rich(
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(text: 'Delegate your stake account to the '),
                TextSpan(text: SPDToken.drop.name, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' pool or deactivate to withdraw your SOL.'),
              ],
            ),
          ),
          [
            SPDSecondaryButton(
              child: Text('Deactivate'), 
              style: SPDSecondaryButton.styleFrom(backgroundColor: SPDColor.shared.primary1),
              onPressed: () => onDeactivate(info),
            ),

            SPDPrimaryButton(
              child: Text('Delegate'), 
              onPressed: () => onDelegate(info),
            ),
          ]
        );
      case DelegationStatus.inactive:
        return _SPDStakeCardData(
          Text(
            'Withdraw the stake account balance to your wallet.', 
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
          ),
          [
            SPDPrimaryButton(
              child: Text('Withdraw'), 
              onPressed: () => onWithdraw(info),
            ),
          ]
        );
      case DelegationStatus.deactivating:
        return _SPDStakeCardData(
          Text(
            'Withdrawals are enabled when the account has finsihed deactivating.',
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
          ),
          [
            SPDPrimaryButton(
              child: Text('Withdraw'), 
              enabled: false,
              onPressed: null,
            ),
          ]
        );
    }
  }

  Widget _buildRow({
    required final String label, 
    required final Widget value,
    required final TextStyle labelStyle,
    TextOverflow? valueOverflow,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(
          label, 
          style: labelStyle, 
          overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(
        width: SPDGrid.x2, 
      ),
      Expanded(
        child: Align(
          alignment: Alignment.topRight,
          child: value,
        ),
      ),
    ],
  );

  @override
  Widget build(final BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color subtitleColor = SPDColor.shared.secondary8;
    final TextStyle subtitleStyle = TextStyle(color: subtitleColor);
    final _SPDStakeCardData data = _data(subtitleColor);
    return Card(
      margin: SPDEdgeInsets.shared.inset(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SPDGrid.x2),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          SPDGrid.x3,
        ),
        child: SPDStackView(
          spacing: SPDGrid.x3,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Stake',
              textAlign: TextAlign.center,
              style: textTheme.titleSmall,
            ),
            SPDStackView(
              spacing: SPDGrid.x2,
              children: [
                SPDStackView(
                  spacing: SPDGrid.x1,
                  children: [
                    _buildRow(
                      label: 'Address', 
                      value: Text(info.address, overflow: TextOverflow.ellipsis), 
                      labelStyle: subtitleStyle, 
                      valueOverflow: TextOverflow.ellipsis,
                    ),
                    _buildRow(
                      label: 'Total Balance', 
                      value: Text('${info.stakeAndRent} SOL'), 
                      labelStyle: subtitleStyle, 
                    ),
                    _buildRow(
                      label: 'Latest Reward', 
                      value: _SPDStakeCardRewards(
                        provider: SolanaWalletProvider.of(context),
                        info: info,
                      ), 
                      labelStyle: subtitleStyle, 
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Divider(height: 0, endIndent: SPDGrid.x2)),
                    Text(info.status.label, style: TextStyle(color: info.status.color)),
                    Expanded(child: Divider(height: 0, indent: SPDGrid.x2)),
                  ],
                ),
                data.message,
              ],
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Flexible(
            //       child: SPDStackView(
            //         spacing: SPDGrid.x1,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('Address', overflow: TextOverflow.ellipsis, style: TextStyle(color: subtitleColor)),
            //           Text('Total Balance', overflow: TextOverflow.ellipsis, style: TextStyle(color: subtitleColor)),
            //         ],
            //       ),
            //     ),
            //     Flexible(
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 16.0),
            //         child: SPDStackView(
            //           spacing: SPDGrid.x1,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             Text(info.address, overflow: TextOverflow.ellipsis,),
            //             Text('${info.stake}8979879879798 SOL'),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     Row(
            //       children: [
            //         Expanded(child: Text(info.address, overflow: TextOverflow.ellipsis,)),
            //         SizedBox(width: SPDGrid.x2),
            //         Text(info.status.label, style: TextStyle(color: info.status.color)),
            //       ],
            //     ),
            //     SizedBox(
            //       height: SPDGrid.x1,
            //     ),
            //     Row(
            //       children: [
            //         Expanded(child: Text('Total Balance', overflow: TextOverflow.ellipsis, style: TextStyle(color: subtitleColor))),
            //         SizedBox(width: SPDGrid.x2),
            //         Text('${info.stake} SOL'),
            //       ],
            //     ),
            //     Divider(
            //       height: SPDGrid.x4,
            //       color: SPDColor.shared.primary4,
            //     ),
            //   ],
            // ),
            if (data.actions.isNotEmpty)
              SPDStackView(
                axis: Axis.horizontal,
                children: data.actions,
              ),
          ],
        ),
      ),
    );
  }
}


/// Stake Card Data
/// ------------------------------------------------------------------------------------------------

class _SPDStakeCardData {

  const _SPDStakeCardData(
    this.message, [
    this.actions = const [],
  ]);

  final Widget message;

  final List<Widget> actions;
}



/// Stake Card Rewards
/// ------------------------------------------------------------------------------------------------

class _SPDStakeCardRewards extends StatefulWidget {

  const _SPDStakeCardRewards({
    super.key, 
    required this.provider, 
    required this.info,  
  });

  final SolanaWalletProvider provider;

  final DelegationInfo info;

  @override
  State<_SPDStakeCardRewards> createState() => _SPDStakeCardRewardsState();
}

class _SPDStakeCardRewardsState extends State<_SPDStakeCardRewards> {
 
  late Future<InflationReward> _future;

  @override
  void initState() {
    super.initState();
    _future = StakeProvider.shared.reward(widget.provider, widget.info);
  }

  Widget _builder(
    final BuildContext context, 
    final AsyncSnapshot<InflationReward> snapshot, 
  ) {
    final InflationReward? reward = snapshot.data;
    if (reward != null) {
      return Text(
        '${lamportsToSol(reward.amount.toBigInt())} SOL',
        style: TextStyle(),
      );
    }
    if (snapshot.hasError) {
      return Text('-');
    }
    return SPDCircularProgressIndicator(radius: 8);
  }
 
 @override
  Widget build(final BuildContext context) => FutureBuilder(
    future: _future,
    builder: _builder, 
  );
}