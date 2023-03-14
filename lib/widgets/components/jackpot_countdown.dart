/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stake_pool_lotto/utils/time.dart';
import '../../themes/fonts/font.dart';


/// Jackpot Countdown
/// ------------------------------------------------------------------------------------------------

class SPDJackpotCountdown extends StatefulWidget {
  
  const SPDJackpotCountdown({
    super.key,
    required this.endDate,
  });

  final DateTime? endDate;

  @override
  State<SPDJackpotCountdown> createState() => _SPDJackpotCountdownState();
}


/// Jackpot Countdown State
/// ------------------------------------------------------------------------------------------------

class _SPDJackpotCountdownState extends State<SPDJackpotCountdown> {

  // String? timestamp(
  //   final LottoConfig? config, 
  //   final LottoDraw? draw,
  //   final EpochInfo? epochInfo) {
    
  //   if (config == null || draw == null || epochInfo == null) {
  //     return null;
  //   }

  //   final int epoch = epochInfo.epoch;
    
  //   print('epoch = $epoch');
  //   print('draw epoch = ${draw.epoch}');

  //   final int elapsedEpochs = epoch - 2842;// draw.epoch.toInt();
  //   if (elapsedEpochs < 0) {
  //     return null;
  //   }

  //   final int remainingEpochs = config.epochsPerDraw - elapsedEpochs;
  //   if (remainingEpochs < 0) {
  //     return null;
  //   }

  //   print('epoch info = ${epochInfo.toJson()}');
  //   final int remainingSlotsInEpoch = epochInfo.slotsInEpoch - epochInfo.slotIndex;
  //   final int remainingSlots = remainingSlotsInEpoch 
  //     + (remainingEpochs * EpochSchedule.minimumSlotPerEpoch);
  //   final double remainingMilliseconds = remainingSlots * millisecondsPerSlot;

  //   print('remaining millis = $remainingMilliseconds');
  //   final duration = Duration(milliseconds: remainingMilliseconds.toInt());

  //   String twoDigits(int n) => n.toString().padLeft(2, "0");

  //   String days = twoDigits(duration.inDays);
  //   String hours = twoDigits(duration.inHours.remainder(24));
  //   String minutes = twoDigits(duration.inMinutes.remainder(60));
  //   String seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "${days}d : ${hours}h : ${minutes}m : ${seconds}s";
  // }

  late final Timer _timer;

  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = SPDTime.shared.remaining(widget.endDate);
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTick(final Timer timer) {
    _duration = SPDTime.shared.remaining(widget.endDate);
    if (_duration.inSeconds > 0) {
      setState(() {});
    } else {
      timer.cancel();
    }
  }

  String _format(final Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String days = twoDigits(duration.inDays);
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${days}d : ${hours}h : ${minutes}m : ${seconds}s";
  }

  @override
  Widget build(final BuildContext context) {
    final Duration duration = _duration;
    return Text(
      _format(duration),
      style: SPDFont.shared.mono(
        SPDFont.shared.body1.fontSize!,
        weight: FontWeight.w300,
      ),
    );
  }
}