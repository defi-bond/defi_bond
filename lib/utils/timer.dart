/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' show max;


/// Timer
/// ------------------------------------------------------------------------------------------------

class SPDTimer {

  /// Creates a timer that expires after [milliseconds] or [duration] has passed. If [autoStart] == 
  /// `true`, start the timer immediately (default: `true`).
  SPDTimer({
    final int? milliseconds,
    final Duration? duration,
    final bool autoStart = true,
  }): assert(milliseconds != null || duration != null),
      milliseconds = milliseconds ?? duration?.inMilliseconds ?? 500 
  {
    if (autoStart) { 
      start(); 
    }
  }

  /// The timer's duration in milliseconds (default: `500`).
  final int milliseconds;

  /// The stopwatch that tracks the elapsed time.
  final Stopwatch _stopwatch = Stopwatch();

  /// Return the remaining time in milliseconds.
  int get remaining {
    return milliseconds - _stopwatch.elapsedMilliseconds;
  }

  /// Start the timer from the current elapsed time.
  void start() {
    _stopwatch.start();
  }

  /// Stop the timer at the current elapsed time.
  void stop() {
    _stopwatch.stop();
  }

  /// Reset the timer's elapsed time to zero.
  void reset() {
    _stopwatch.reset();
  }

  /// Executes [callback] once the timer expires.
  Future<T?> onComplete<T>(final T? Function() callback) {
    return Future.delayed(Duration(milliseconds: max(0, remaining)), callback);
  }

  /// Resolves [future] once the timer expires.
  Future<T?> onFutureComplete<T>(final Future<T?> future) async {
    return (await Future.wait<T?>([future, onComplete(() => null)], eagerError: false))[0];
  }
}