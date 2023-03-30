/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:stake_pool_lotto/layouts/grid.dart';
import 'package:stake_pool_lotto/providers/stake_provider.dart';
import 'package:stake_pool_lotto/widgets/components/solana_logo.dart';
import 'package:stake_pool_lotto/widgets/components/stake_account_logo.dart';
import '../tiles/list_tile.dart';
import '../../providers/price_provider.dart';
import '../../utils/format.dart';


/// Stake Tile
/// ------------------------------------------------------------------------------------------------

class SPDStakeTile extends StatelessWidget {
  
  /// Creates a list item to display a stake account.
  const SPDStakeTile({ 
    super.key,
    required this.index,
    required this.info,
    this.onTap,
  });

  final int index;

  final DelegationInfo info;

  final void Function(DelegationInfo info)? onTap;

  /// Build the final widget.
  @override
  Widget build(final BuildContext context) {
    final double amount = info.stakeAndRent;
    final double balance = amount * PriceProvider.shared.price;
    final StakeValidatorInfo? stakeValidatorInfo = StakeProvider.shared.validators[info.vote];
    return SPDListTile(
      leading: CircleAvatar(
        radius: SPDGrid.x3 * 0.5,
        backgroundImage: AssetImage(
          stakeValidatorInfo?.logo ?? 'assets/images/stake_account_logo.png',
        ),
      ),
      onTap: () => onTap?.call(info),
      title: Text(
        stakeValidatorInfo?.name ?? 'Stake ${index+1}',
        overflow: TextOverflow.ellipsis,
      ),
      titleTrailing: Text('${formatNumber(amount, dps: 4)} SOL'),
      subtitle: Text(
        info.status.label,
        style: TextStyle(color: info.status.color),
      ),
      // Row(
      //   children: [
      //     Container(
      //       width: SPDGrid.x1,
      //       height: SPDGrid.x1,
      //       decoration: BoxDecoration(
      //         color: info.status.color,
      //         shape: BoxShape.circle,
      //       ),
      //     ),
      //     SizedBox(
      //       width: SPDGrid.x1,
      //     ),
      //     Text(
      //       info.status.label,
      //       style: TextStyle(color: info.status.color),
      //     ),
      //   ],
      // ),
      subtitleTrailing: Text('\$${formatCurrency(balance)}'),
    );
  }
}