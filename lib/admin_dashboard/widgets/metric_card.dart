import 'package:flutter/material.dart';
import 'chart_utils.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, String> selectedRange;
  final Map<String, Map<String, double>> sampleData;
  final double totalGlobal;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.selectedRange,
    required this.sampleData,
    required this.totalGlobal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedRange[title] ?? '1M';
    final value = sampleData[title]?[selected] ?? 0.0;

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width / 2;

      final scale = (w / 180).clamp(0.9, 1.06);

      final titleSize = 12.0 * scale;
      final valueSize = 14.0 * scale;
      final iconSize = (18.0 * scale).clamp(16.0, 22.0);
      final horizontalPadding = (10.0 * scale).clamp(8.0, 14.0);
      final verticalPadding = (10.0 * scale).clamp(8.0, 12.0);

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                // IMPORTANT: do not let Column expand; keep it tight to contents
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row — icon + label
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6 * scale),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, size: iconSize, color: Colors.indigo),
                      ),
                      SizedBox(width: 8 * scale),

                      // Title should shrink when space is tight
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Total $title",
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10 * scale),

                  Row(
                    children: [
                      // LEFT → Value
                      Expanded(
                        child: Text(
                          "₹${formatNumber(value)}",
                          style: TextStyle(
                            fontSize: valueSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
