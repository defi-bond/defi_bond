/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math' as math show max;
import 'time_zone.dart';


/// Time
/// ------------------------------------------------------------------------------------------------

class SPDTime {

  /// Provides properties and methods for working with dates and times.
  const SPDTime._();

  /// The [SPDTime] class' singleton instance.
  static const SPDTime shared = SPDTime._();

  /// Return the current date time in the given [timeZone].
  /// @param [timeZone]: The time zone of the returned data time (default: [SPDTimeZone.utc]).
  DateTime now([SPDTimeZone timeZone = SPDTimeZone.utc]) {
    final DateTime now = DateTime.now();
    return timeZone == SPDTimeZone.utc ? now.toUtc() : now;
  }

  /// Return the current timestamp in the given [timeZone].
  /// @param [timeZone]: The time zone of the returned timestamp (default: [SPDTimeZone.utc]).
  int timestamp([SPDTimeZone timeZone = SPDTimeZone.utc]) {
    return now(timeZone).millisecondsSinceEpoch;
  }

  /// Return the elapsed [Duration] between the current time and [dateTime]. A `positive` [Duration] 
  /// is returned for past [dateTime]s and a `negative` [Duration] for future [dateTime]s.
  /// @param [dateTime]?: The date time to compute the elapsed duration for.
  Duration elapsed(DateTime? dateTime) {
    return dateTime == null
      ? const Duration(seconds: 0)
      : now(SPDTimeZone.utc).difference(dateTime.toUtc());
  }

  /// Return the remaining [Duration] between the current time and [dateTime]. If [dateTime] is in the 
  /// future, a `positive` [Duration] is returned, else [Duration.zero] is returned.
  /// @param [dateTime]?: The date time to compute the remaining duration for.
  Duration remaining(DateTime? dateTime) {
    final int milliseconds = elapsed(dateTime).inMilliseconds;
    return Duration(milliseconds: math.max(0, -milliseconds));
  }

  /// Return `true` if [dateTime] is greater than or equal to the current time.
  /// @param [dateTime]?: The date time to test for expiration.
  bool expired(DateTime? dateTime) {
    return elapsed(dateTime) >= Duration.zero;
  }

  /// Return a future [DateTime] in the UTC timezone, offset by [duration].
  /// @param [duration]: The duration to add to the current time.
  DateTime expiry(Duration duration) {
    return now(SPDTimeZone.utc).add(duration);
  }

  /// Convert [timestamp] to a [DateTime] instance. The value of [timestamp] must be the number of 
  /// milliseconds since epoch, represented as an [int] or [String]. Return `null` if [timestamp] 
  /// represents an invalid date (i.e. `null` or a negative [int]).
  /// @param [timestamp]?: The number of milliseconds since epoch.
  /// @param [isUTC]: If `false`, return the epoch [timestamp] in the local timezone.
  DateTime? decode(dynamic timestamp, { required bool isUTC }) {
    assert(timestamp == null || timestamp is int || timestamp is String);
    if(timestamp is String) {
      timestamp = int.tryParse(timestamp);
    }
    final bool isInvalid = timestamp == null || timestamp < 0;
    return isInvalid ? null : DateTime.fromMillisecondsSinceEpoch(timestamp!, isUtc: isUTC);
  }

  /// Convert [dateTime] to an [int]. The value is the number of milliseconds since epoch. Return 
  /// `null` if [dateTime] is `null`.
  /// @param [dateTime]?: The date time to encode as an epoch timestamp.
  int? encode(DateTime? dateTime) {
    return dateTime?.millisecondsSinceEpoch;
  }
}