import 'package:flutter/material.dart';

class GlobalRangeRow extends StatelessWidget {
  final List<String> ranges;
  final String globalRange;
  final ValueChanged<String> onChange;

  const GlobalRangeRow({
    super.key,
    required this.ranges,
    required this.globalRange,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final scale = (w / 360).clamp(0.85, 1.15);

        final double btnHeight = (34 * scale).clamp(28, 38);
        final double fontSize = (12 * scale).clamp(10, 14);
        final double horizontalPadding = (6 * scale).clamp(4, 10);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ranges.map((r) {
            final active = globalRange == r;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SizedBox(
                  height: btnHeight, // ⭐ Smaller responsive height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          active ? Colors.indigo : Colors.grey.shade100,
                      foregroundColor:
                          active ? Colors.white : Colors.black87,
                      elevation: active ? 2 : 0,
                      padding: EdgeInsets.zero, // ⭐ removes extra height
                      side: BorderSide(
                        color: active
                            ? Colors.indigo
                            : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => onChange(r),
                    child: Text(
                      r,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize, // ⭐ responsive text
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
