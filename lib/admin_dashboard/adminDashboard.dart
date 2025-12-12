import 'package:flutter/material.dart';
import 'widgets/total_users_card.dart';

import 'widgets/global_range_row.dart';
import 'widgets/metric_card.dart';
import 'widgets/pie_chart_card.dart';
// import 'widgets/line_chart_card.dart';

class DashboardCardsPage extends StatefulWidget {
  const DashboardCardsPage({Key? key}) : super(key: key);

  @override
  State<DashboardCardsPage> createState() => _DashboardCardsPageState();
}

class _DashboardCardsPageState extends State<DashboardCardsPage> {
  int totalUsers = 50;

  final Map<String, String> selectedRange = {
    'Investment': '1M',
    'Policy': '1M',
    'Insurance': '1M',
    'Loan': '1M',
  };

  final List<String> ranges = ['1M', '3M', '6M', '1Y'];

  String globalRange = '1M';
  String activeMetric = 'Investment';

  final Map<String, Map<String, double>> sampleData = {
    'Investment': {'1M': 12000, '3M': 36000, '6M': 72000, '1Y': 140000},
    'Policy': {'1M': 8000, '3M': 24000, '6M': 48000, '1Y': 96000},
    'Insurance': {'1M': 6000, '3M': 18000, '6M': 36000, '1Y': 72000},
    'Loan': {'1M': 15000, '3M': 45000, '6M': 90000, '1Y': 180000},
  };

  @override
  Widget build(BuildContext context) {
    double totalGlobal = sampleData.keys
        .map((k) => sampleData[k]![globalRange] ?? 0)
        .fold(0.0, (a, b) => a + b);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TotalUsersCard(totalUsers: totalUsers),
              const SizedBox(height: 10),

              // SlidingGlobalRangeRow Section
              GlobalRangeRow( ranges: ranges, globalRange: globalRange, onChange: (r) { setState(() { globalRange = r; selectedRange.updateAll((key, value) => r); }); }, ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.6,
                        children: [
                          MetricCard(
                              title: "Investment",
                              selectedRange: selectedRange,
                              sampleData: sampleData,
                              totalGlobal: totalGlobal,
                              icon: Icons.bar_chart,
                              onTap: () {
                                setState(() => activeMetric = "Investment");
                              }),
                          MetricCard(
                              title: "Policy",
                              selectedRange: selectedRange,
                              sampleData: sampleData,
                              totalGlobal: totalGlobal,
                              icon: Icons.description,
                              onTap: () {
                                setState(() => activeMetric = "Policy");
                              }),
                          MetricCard(
                              title: "Insurance",
                              selectedRange: selectedRange,
                              sampleData: sampleData,
                              totalGlobal: totalGlobal,
                              icon: Icons.security,
                              onTap: () {
                                setState(() => activeMetric = "Insurance");
                              }),
                          // MetricCard Section
                          MetricCard(
                              title: "Loan",
                              selectedRange: selectedRange,
                              sampleData: sampleData,
                              totalGlobal: totalGlobal,
                              icon: Icons.credit_card,
                              onTap: () {
                                setState(() => activeMetric = "Loan");
                              }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // PieChartCard Section

                      PieChartCard(
                        selectedRange: selectedRange,
                        sampleData: sampleData,
                      ),
                      const SizedBox(height: 12),
                      // LineChartCard Section

                      // LineChartCard(
                      //   metric: activeMetric,
                      //   selectedRange: selectedRange,
                      //   sampleData: sampleData,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
