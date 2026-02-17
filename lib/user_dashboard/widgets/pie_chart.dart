import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPieChart extends StatelessWidget {
  final Map<String, double> data;
  final String?
      selectedKey; // the currently selected category title (e.g. "Investment")
  final ValueChanged<String>? onSectionTap; // callback when a slice is tapped

  const DashboardPieChart({
    super.key,
    required this.data,
    this.selectedKey,
    this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (sum, item) => sum + item);

    // stable ordering so indexes map to keys
    final entries = data.entries.toList();

    // compute center label for selected slice (or show total)
    String centerTitle;
    String centerSubtitle;
    if (selectedKey != null && data.containsKey(selectedKey)) {
      final value = data[selectedKey]!;
      final pct = total > 0 ? (value / total) * 100.0 : 0.0;
      centerTitle = selectedKey!;
      centerSubtitle = "${pct.toStringAsFixed(1)}%";
    } else {
      centerTitle = "Total";
      centerSubtitle = "₹${total.toInt()}";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Total: ₹${total.toInt()}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 50,
                    startDegreeOffset: -90,
                    sections: _getSections(entries),
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        // Only treat tap-up events as selection (ignore drags/long press)
                        if (event is FlTapUpEvent &&
                            pieTouchResponse != null &&
                            pieTouchResponse.touchedSection != null) {
                          final idx = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                          if (idx < 0 || idx >= entries.length) return;
                          final key = entries[idx].key;
                          if (onSectionTap != null) onSectionTap!(key);
                        }
                      },
                    ),
                  ),
                ),

                // Center label (shows selected slice name + percent OR total)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      centerTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      centerSubtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Build sections from ordered entries (so index <-> key mapping is stable)

  List<PieChartSectionData> _getSections(
      List<MapEntry<String, double>> entries) {
    final colors = [
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
      // add more if needed
    ];

    // helper: truncate long labels
    String truncateLabel(String label, int maxChars) {
      if (label.length <= maxChars) return label;
      return label.substring(0, maxChars - 1) + '…';
    }

    int i = 0;
    return entries.map((e) {
      final isSelected = (selectedKey != null && selectedKey == e.key);

      // choose how many characters to allow — adjust if you have small slices
      final int maxLabelChars = 12; // try 8-12 depending on available space
      final displayKey = truncateLabel(e.key, maxLabelChars);

      // Build title: key on first line (possibly truncated) and numeric value below
      final titleText = "$displayKey\n${e.value.toInt()}";

      final section = PieChartSectionData(
        color: colors[i % colors.length],
        value: e.value,
        radius: isSelected ? 60 : 55, 
        title: titleText,
        titleStyle: TextStyle(
          fontSize:(displayKey.length > 8) ? 8 : 9, 
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        borderSide: isSelected
            ? const BorderSide(color: Colors.black12, width: 2)
            : null,
        showTitle: true,
      );
      i++;
      return section;
    }).toList();
  }
}
