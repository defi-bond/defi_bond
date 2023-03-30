/// Imports
/// ------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stake_pool_lotto/constants.dart';
import 'package:stake_pool_lotto/layouts/padding.dart';
import 'package:stake_pool_lotto/widgets/animations/fade_and_scale_switcher.dart';
import 'package:stake_pool_lotto/widgets/animations/fade_and_size_switcher.dart';
import '../../layouts/grid.dart';
import '../../providers/jackpot_provider.dart';
import '../../providers/price_provider.dart';
import '../../utils/format.dart';
import '../../widgets/components/jackpot_countdown.dart';
import '../../widgets/indicators/circular_progress_indicator.dart';


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

class _SPDJackpotState extends State<SPDJackpot> {

  Duration _timeRemaining(final DateTime utcNow) {
    final DateTime utc6pm = DateTime.utc(utcNow.year, utcNow.month, utcNow.day, 18);
    final int daysUntilFriday = (DateTime.friday - utcNow.weekday) % DateTime.sunday;
    final Duration timeUntil6pm = utcNow.difference(utc6pm);
    final Duration days = Duration(days: daysUntilFriday == 0 ? 7 : daysUntilFriday);
    return days - timeUntil6pm;
  }

  Widget _build(
    final JackpotProvider jackpotProvider, 
    final PriceProvider priceProvider,
    final TextTheme textTheme,
  ) {
    final DateTime utcNow = DateTime.now().toUtc();
    final double balance = jackpotProvider.tokenBalance;
    final Duration remaining = _timeRemaining(utcNow);
    final double price = priceProvider.price;
    final DateTime endDate = utcNow.add(remaining);
    final double jackpot = balance * price;
    final int dps = jackpot < 100000 ? 2 : 0;
    return Center(
      child: Column(
        children: [
          Text(
            '\$${formatCurrency(jackpot, dps: dps)}',
            style: textTheme.displayMedium,
          ),
          const SizedBox(
            height: SPDGrid.x1 * 0.5,
          ),
          SPDJackpotCountdown(
            endDate: endDate,
          ),
        ],
      ),
    );
  }

  Widget _builder(
    final BuildContext context, 
    final JackpotProvider jackpotProvider, 
    final PriceProvider priceProvider, 
    final Widget? child,
  ) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
        padding: EdgeInsets.only(
          bottom: SPDGrid.x1 * 0.5,
        ),
        child: Text(
          'Estimated drop',
          style: textTheme.titleSmall,
        ),
      ),
        SPDFadeAndScaleSwitcher(
          duration: animationDuration,
          child: !jackpotProvider.isUpdated || !priceProvider.isUpdated
            ? Padding(
                padding: SPDEdgeInsets.shared.inset(),
                child: const SPDCircularProgressIndicator(),
              )
            : _build(jackpotProvider, priceProvider, textTheme),
        ),
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Consumer2<JackpotProvider, PriceProvider>(
      builder: _builder,
    );
  }
}