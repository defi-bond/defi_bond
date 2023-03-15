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