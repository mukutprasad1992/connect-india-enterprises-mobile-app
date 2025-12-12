import 'package:flutter/material.dart';

class TotalUsersCard extends StatelessWidget {
  final int totalUsers;

  const TotalUsersCard({super.key, required this.totalUsers});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to adapt to available width
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;

      // scale factor based on width (clamped)
      final scale = (w / 360).clamp(0.85, 1.25);

      final double titleSize = 12 * scale;
      final double countSize = 18 * scale;
      final double subtitleSize = 10 * scale;
      final double horizontalPadding = (w * 0.04).clamp(12.0, 28.0);
      final double verticalPadding = 12 * (scale.clamp(0.9, 1.2));

      return SizedBox(
        width: double.infinity, // try to take full available width
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Row(
            // Row so we can increase perceived width and allow adding icons later
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Users",
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6 * (scale.clamp(0.9, 1.2))),
                    Text(
                      "$totalUsers",
                      style: TextStyle(
                        fontSize: countSize,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4 * (scale.clamp(0.9, 1.2))),
                    Text(
                      "Active users using the app",
                      style: TextStyle(fontSize: subtitleSize, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Right: optional place for an icon / small sparkline or KPI
              SizedBox(
                width: (w * 0.18).clamp(40.0, 90.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.people_alt,
                    size: (18 * scale).clamp(16.0, 30.0),
                    color: Colors.indigo.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
