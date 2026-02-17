
/// Format numbers succinctly (k, L, Cr)
String formatNumber(double n) {
  if (n >= 10000000) return '${(n / 10000000).toStringAsFixed(1)} Cr';
  if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)} L';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return n.toStringAsFixed(0);
}

/// Linear interpolate between a and b by t in [0..1]
double lerpDouble(double a, double b, double t) => a + (b - a) * t.clamp(0.0, 1.0);

/// Radius used for mini pies inside metric cards (proportion in [0..1])
double radiusForMiniPie(double proportion) {
  final s = proportion.clamp(0.0, 1.0);
  return lerpDouble(20, 50, s);
}

/// Generate a simple synthetic timeseries for the metric.
/// Keeps the sum approx equal to the provided value for the selected range.
List<double> getTimeSeriesFor(String metric, String range, Map<String, Map<String, double>> sampleData) {
  final total = sampleData[metric]?[range] ?? 0.0;
  final months = _monthsForRange(range);
  if (months == 0) return [];

  final List<double> factors = List.generate(months, (i) {
    final factor = 0.6 + (i / (months - 1 + 0.00001)) * 1.4; 
    return factor;
  });

  final sumFactors = factors.reduce((a, b) => a + b);
  final scale = (sumFactors == 0) ? 0.0 : (total / sumFactors);
  return factors.map((f) => double.parse((f * scale).toStringAsFixed(2))).toList();
}

/// Labels for bottom axis for given range (e.g., "9/25")
List<String> labelsForRange(String range) {
  final months = _monthsForRange(range);
  final now = DateTime.now();
  final labels = <String>[];
  for (int i = months - 1; i >= 0; i--) {
    final d = DateTime(now.year, now.month - i, 1);
    labels.add('${d.month}/${d.year.toString().substring(2)}');
  }
  return labels;
}

int _monthsForRange(String range) {
  switch (range) {
    case '1M':
      return 1;
    case '3M':
      return 3;
    case '6M':
      return 6;
    case '1Y':
      return 12;
    default:
      return 1;
  }
}
