import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'chart_utils.dart';

class PieChartCard extends StatelessWidget {
  final Map<String, String> selectedRange;
  final Map<String, Map<String, double>> sampleData;

  const PieChartCard({
    super.key,
    required this.selectedRange,
    required this.sampleData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Responsive text scale
        final scale = (width / 350).clamp(0.8, 1.2);

        // Read values
        final entries = sampleData.entries.map((e) {
          final range = selectedRange[e.key] ?? '1M';
          final value = e.value[range] ?? 0.0;
          return MapEntry(e.key, value);
        }).toList();

        final total = entries.fold(0.0, (s, e) => s + e.value);

        // Colors
        final colors = [
          const Color(0xFF42A5F5),
          const Color(0xFF66BB6A),
          const Color(0xFF26A69A),
          const Color(0xFFEF5350),
        ];

        // Pie sections
        final sections = List.generate(entries.length, (i) {
          final key = entries[i].key;
          final value = entries[i].value;
          final share = (total == 0) ? 0.0 : value / total;

          final radius = lerpDouble(30, 70, share); // smaller, more responsive
          final label = '$key\n₹${formatNumber(value)}';

          return PieChartSectionData(
            color: colors[i % colors.length],
            value: value,
            radius: radius,
            title: label,
            titleStyle: TextStyle(
              fontSize: 10 * scale,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        });

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(14 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ⭐ Updated Title
              Text(
                'Category-wise Distribution',
                style: TextStyle(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 10 * scale),

              /// Responsive Pie Chart
              SizedBox(
                height: (width * 0.55).clamp(180, 260), // auto-adjust height
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4 * scale,
                    centerSpaceRadius: 40 * scale,
                    sections: sections,
                    startDegreeOffset: -90,
                  ),
                ),
              ),

              SizedBox(height: 8 * scale),

              /// Total Amount
              Text(
                'Total: ₹${formatNumber(total)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13 * scale,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 10 * scale),
              /// ⭐ Clean Legend (Responsive)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: List.generate(entries.length, (i) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12 * scale,
                        height: 12 * scale,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 6 * scale),
                      Text(
                        entries[i].key,
                        style: TextStyle(
                          fontSize: 11 * scale,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
