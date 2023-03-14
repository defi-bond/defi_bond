/// Duration
/// ------------------------------------------------------------------------------------------------

class SPDDuration {

  /// Provides properties and methods for common durations.
  const SPDDuration._();

  /// Return the fastest animation duration.
  static Duration get fast {
    return const Duration(milliseconds: 150);
  }

  /// Return the normal animation duration.
  static Duration get normal {
    return const Duration(milliseconds: 300);
  }

  /// Return the slow animation duration.
  static Duration get slow {
    return const Duration(milliseconds: 600);
  }

  /// Return the slowest animation duration.
  static Duration get slowest {
    return const Duration(milliseconds: 1200);
  }
}