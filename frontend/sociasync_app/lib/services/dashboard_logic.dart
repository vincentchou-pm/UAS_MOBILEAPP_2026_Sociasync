int asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '0') ?? 0;
}

double asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '0') ?? 0.0;
}

String formatCompact(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$value';
}

String shortDayLabel(DateTime? date) {
  if (date == null) return '-';
  const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  return labels[date.weekday - 1];
}

String firstNotEmpty(List<dynamic> values) {
  for (final value in values) {
    final parsed = (value ?? '').toString().trim();
    if (parsed.isNotEmpty) {
      return parsed;
    }
  }
  return '';
}