
import 'dart:math';

String _formatLabel(int i, { required List<String> labels }) {
  return i < labels.length ? labels[i] : '';
}

String format(final num value, { int dps = 2, required final List<String> labels }) {
  
  if (value == 0) {
    return '$value${_formatLabel(0, labels: labels)}';
  }

  const int k = 1000;
  dps = dps < 0 ? 0 : dps;
  final int absValue = value.floor().abs();
  final int i = absValue == 0 ? 0 : (log(absValue) / log(k)).floor();

  final double number = value / pow(k, i);
  final bool hasRemainder = value.floorToDouble() != number;
  final String numberString = number.toStringAsFixed(hasRemainder ? dps : 0);
  return numberString.replaceFirst(RegExp(r'\.0+$'), '') + _formatLabel(i, labels: labels);
}

String formatBytes(final num bytes, { final int dps = 2 }) {
  return format(bytes, dps: dps, labels: const [
    ' Bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB'
  ]);
}

String abbreviation(final num value, { final int dps = 2 }) {
  return format(value, dps: dps, labels: const ['', 'K', 'M', 'M', 'B', 'T']);
}