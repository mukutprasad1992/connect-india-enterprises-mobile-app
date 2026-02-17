// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'chart_utils.dart';

// class LineChartCard extends StatelessWidget {
//   final String metric;
//   final Map<String, String> selectedRange;
//   final Map<String, Map<String, double>> sampleData;
//   final VoidCallback? onChangeMetric;

//   const LineChartCard({
//     super.key,
//     required this.metric,
//     required this.selectedRange,
//     required this.sampleData,
//     this.onChangeMetric,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final range = selectedRange[metric] ?? '1M';
//     final series = getTimeSeriesFor(metric, range, sampleData);
//     final labels = labelsForRange(range);

//     final spots = List.generate(series.length, (i) => FlSpot(i.toDouble(), series[i]));
//     final maxY = (series.isEmpty) ? 1.0 : (series.reduce((a, b) => a > b ? a : b) * 1.2);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text('$metric — $range', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//           TextButton(onPressed: onChangeMetric, child: const Text('Change'))
//         ]),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 200,
//           child: LineChart(
//             LineChartData(
//               minX: 0,
//               maxX: (spots.isEmpty) ? 1 : (spots.length - 1).toDouble(),
//               minY: 0,
//               maxY: maxY,
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, meta) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)))),
//                 bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
//                   final idx = v.toInt();
//                   if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
//                   return Text(labels[idx], style: const TextStyle(fontSize: 10));
//                 })),
//               ),
//               gridData: FlGridData(show: true),
//               lineBarsData: [
//                 LineChartBarData(spots: spots, isCurved: true, barWidth: 3, dotData: FlDotData(show: true)),
//               ],
//             ),
//           ),
//         ),
//       ]),
//     );
//   }
// }
