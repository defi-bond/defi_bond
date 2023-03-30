/// Imports
/// ------------------------------------------------------------------------------------------------

import 'dart:math';


/// Formatting
/// ------------------------------------------------------------------------------------------------

/// Returns the label at [index] or an empty string.
String _shortLabel(final int index, { required List<String> labels }) {
  return index < labels.length ? labels[index] : '';
}

/// Returns a short-form representation of [value].
String abbreviate(final num value, { int? dps, required final List<String> labels }) {
  
  if (value == 0) {
    return '$value${_shortLabel(0, labels: labels)}';
  }

  dps ??= 2;
  const int k = 1000;
  dps = dps < 0 ? 0 : dps;
  final int absValue = value.floor().abs();
  final int i = absValue == 0 ? 0 : (log(absValue) / log(k)).floor();

  final double number = value / pow(k, i);
  final bool hasRemainder = value.floorToDouble() != number;
  final String numberString = number.toStringAsFixed(hasRemainder ? dps : 0);
  return numberString.replaceFirst(RegExp(r'\.0+$'), '') + _shortLabel(i, labels: labels);
}

/// Formats [value].
/// ```
/// final formatted = abbreviateNumber(1000);
/// print(formatted); // 1K
/// ```
String abbreviateNumber(final num value, { final int? dps }) {
  return abbreviate(value, dps: dps, labels: const ['', 'K', 'M', 'M', 'B', 'T']);
}

String formatNumberString(final String value, { required final int minDps }) {
  // assert(minDps <= maxDps);
  // final String numberString = value.toStringAsFixed(maxDps);
  final List<String> parts = value.split('.');
  final Pattern pattern = RegExp(r'\B(?=(\d{3})+(?!\d))');
  parts[0] = parts[0].replaceAllMapped(pattern, (final Match match) => ',');
  if (parts.length > 1) {
    parts[1] = parts[1].replaceFirst(RegExp(r'0+$'), '', minDps);
    if (parts[1].isEmpty) return parts[0];
  }
  return parts.join('.');
}

String formatNumber(final num value, { final int dps = 9 }) {
  return formatNumberString(value.toStringAsFixed(dps), minDps: 0);
}

String formatCurrency(final num value, { final int dps = 2 }) {
  return formatNumberString(value.toStringAsFixed(dps), minDps: dps);
}