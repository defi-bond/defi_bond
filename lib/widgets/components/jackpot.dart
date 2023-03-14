/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions/text_style.dart';
import '../../providers/jackpot_provider.dart';
import '../../widgets/components/jackpot_countdown.dart';
import '../../widgets/indicators/circular_progress_indicator.dart';
import '../../layouts/grid.dart';
import '../../providers/price_provider.dart';
import '../../themes/fonts/font.dart';


/// Jackpot
/// ------------------------------------------------------------------------------------------------

class SPDJackpot extends StatefulWidget {

  const SPDJackpot({
    super.key,
  });

  @override
  State<SPDJackpot> createState() => _SPDJackpotState();
}


/// Jackpot State
/// ------------------------------------------------------------------------------------------------

// class _SPLDrawDate {
//   const _SPLDrawDate(
//     this.date,
//     this.duration,
//   );
//   final DateTime date;
//   final Duration duration;
// }

class _SPDJackpotState extends State<SPDJackpot> {

  Duration timeRemaining(final DateTime utcNow) {
    final DateTime utc6pm = DateTime.utc(utcNow.year, utcNow.month, utcNow.day, 18);
    final int daysUntilFriday = (DateTime.friday - utcNow.weekday) % DateTime.sunday;
    final Duration timeUntil6pm = utcNow.difference(utc6pm);
    final Duration days = Duration(days: daysUntilFriday == 0 ? 7 : daysUntilFriday);
    return days - timeUntil6pm;
  }

  // double calculateJackpot(final JackpotInfo jackpotInfo, final int epochs) {

  //   final double solStaked = 383822508                        // Number of stake SOL
  //     / lamportsToSol(jackpotInfo.supply.total.toBigInt());   // Total SOL

  //   print('SOL STAKED = ${solStaked}');
    
  //   final double stakingYield = 
  //     jackpotInfo.inflationRate.validator // Validator inflation rate
  //     * 0.9                               // Validator uptime
  //     * (1 - 0.1)                         // Validator fee
  //     * (1 / solStaked);

  //   print('SOL YIELD  = ${stakingYield}');

  //   final double tokenSupply = lamportsToSol(jackpotInfo.tokenSupply.amount);
  //   final double reserveBalance = lamportsToSol(jackpotInfo.reserveStakeBalance.toBigInt());
  //   final int remainingEpochs = max(0, epochs - 1);
  //   const int daysInYear = 365;

  //   final double estimatedRewards = stakingYield
  //     * max(0, tokenSupply - reserveBalance)
  //     * (remainingEpochs / daysInYear);

  //   final double reserveRewards = stakingYield
  //     * max(0, reserveBalance - lamportsPerSol)
  //     * (1 / daysInYear);

  //   print('ESTIMATED REWARDS $estimatedRewards');
  //   print('RESERVE   REWARDS $reserveRewards');

  //   final double total = max(
  //     0,
  //     estimatedRewards + reserveRewards
  //       + lamportsToSol(jackpotInfo.rolloverBalance.toBigInt())
  //       + lamportsToSol(jackpotInfo.feeBalance.toBigInt())
  //   );

  //   print('ROLLOVER       = ${lamportsToSol(jackpotInfo.rolloverBalance.toBigInt())}');
  //   print('EPOCH FEE      = ${lamportsToSol(jackpotInfo.feeBalance.toBigInt())}');
  //   print('RESERVE        = ${lamportsToSol(jackpotInfo.reserveStakeBalance.toBigInt())}');
  //   print('TOKEN SUPPLY   = ${lamportsToSol(jackpotInfo.tokenSupply.amount)}');
  //   // TOKEN SUPPLY  = 1.026510066 = 2.057048928

  //   return total;
  // }

  Widget _build(
    final JackpotProvider jackpotProvider, 
    final PriceProvider priceProvider,
  ) {
    final DateTime utcNow = DateTime.now().toUtc();
    final double balance = jackpotProvider.tokenBalance;
    final Duration remaining = timeRemaining(utcNow);
    final double price = priceProvider.price;
    final DateTime endDate = utcNow.add(remaining);
    final double jackpot = balance * price;

    // if (!jackpotProvider.isError && !priceProvider.isError) {

    //   final JackpotInfo? jackpotInfo = jackpotProvider.value;

    //   if (jackpotInfo != null) {
        
    //     final _SPLDrawDate drawDate = calculateDrawDate(jackpotInfo);
        
    //     final EpochInfo epochInfo = jackpotInfo.epochInfo;
    //     final int remainingSlots = epochInfo.slotsInEpoch - epochInfo.slotIndex;
    //     final int remainingMilliseconds = (remainingSlots * millisecondsPerSlot).floor();
    //     final int epochMilliseconds = (epochInfo.slotsInEpoch * millisecondsPerSlot).floor();
    //     final int remainingEpochs = (drawDate.duration.inMilliseconds / epochMilliseconds).ceil();
    //     print('\n');
    //     print('REMAINING SLOTS  = ${jackpotInfo.epochInfo.toJson()}');
    //     print('DURATION         = ${drawDate.duration.inMilliseconds}');
    //     print('REMAINING MILLI  = $remainingMilliseconds');
    //     print('EPOCH LENGTH     = ${epochMilliseconds}');
    //     print('EPOCH REMAINING  = ${remainingEpochs}');
    //     print('\n');

    //     final double total = calculateJackpot(jackpotInfo, remainingEpochs);
    //     final int dps = total < 10000 ? 2 : 0;
    //     jackpot = '\$${total.toStringAsFixed(10)}';
    //     endDate = drawDate.date;
    //   }
    // }

    return Column(
      children: [
        SPDJackpotCountdown(
          endDate: endDate,
        ),
        Text(
          '\$${jackpot.toStringAsFixed(2)}',
          style: SPDFont.shared.medium(48.0),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    final JackpotProvider jackpotProvider = context.watch<JackpotProvider>();
    final PriceProvider priceProvider = context.watch<PriceProvider>();
    return Column(
      children: [
        Text(
          'Estimated Drop',
          style: SPDFont.shared.headline3.medium(),
        ),
        const SizedBox(
          height: SPDGrid.x2,
        ),
        !jackpotProvider.isUpdated || !priceProvider.isUpdated
          ? const SPDCircularProgressIndicator()
          : _build(jackpotProvider, priceProvider),
      ],
    );
  }
}