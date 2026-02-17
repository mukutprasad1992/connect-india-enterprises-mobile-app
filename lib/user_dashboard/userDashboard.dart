import 'package:flutter/material.dart';
import './widgets/grid.dart';
import './widgets/pie_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> summaryData = [
    {
      "title": "Total Investment",
      "count": 25,
      "amount": 45000,
      "percentage": 12,
      "monthlyChange": 1200,
      "icon": Icons.bar_chart,
      "color": const Color(0xFFF87171),
    },
    {
      "title": "Total Policy",
      "count": 15,
      "amount": 22500,
      "percentage": -3,
      "monthlyChange": -600,
      "icon": Icons.description,
      "color": const Color(0xFF3B82F6),
    },
    {
      "title": "Total Insurance",
      "count": 10,
      "amount": 18000,
      "percentage": 5,
      "monthlyChange": 900,
      "icon": Icons.shield,
      "color": const Color(0xFF2DD4BF),
    },
    {
      "title": "Total Loan",
      "count": 12,
      "amount": 33900,
      "percentage": 8,
      "monthlyChange": 1800,
      "icon": Icons.credit_card,
      "color": const Color(0xFF1E40AF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selected = summaryData[selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // SUMMARY CARD (top)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SummaryCard(
                title: selected["title"],
                totalCount: selected["count"],
                amount: selected["amount"],
                percentage: (selected["percentage"] as num).toDouble(),
                monthlyChange: selected["monthlyChange"],
                changeColor: (selected["percentage"] as num) >= 0
                    ? Colors.green
                    : Colors.red,
                changeIcon: (selected["percentage"] as num) >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                headerColor: selected["color"],
              ),
            ),
            const SizedBox(height: 10),

            // GRID: generate from summaryData (two columns)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // build rows of two
                      for (int r = 0; r < (summaryData.length / 2).ceil(); r++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: summaryData[r * 2]["title"],
                                  subtitle: '₹ ${summaryData[r * 2]["amount"]}',
                                  value:
                                      '₹ ${(summaryData[r * 2]["amount"] / 1000).toStringAsFixed(1)}k',
                                  icon: summaryData[r * 2]["icon"],
                                  iconColor: summaryData[r * 2]["color"],
                                  isSelected: selectedIndex == r * 2,
                                  onTap: () =>
                                      setState(() => selectedIndex = r * 2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (r * 2 + 1 < summaryData.length)
                                Expanded(
                                  child: StatCard(
                                    title: summaryData[r * 2 + 1]["title"],
                                    subtitle:
                                        '₹ ${summaryData[r * 2 + 1]["amount"]}',
                                    value:
                                        '₹ ${(summaryData[r * 2 + 1]["amount"] / 1000).toStringAsFixed(1)}k',
                                    icon: summaryData[r * 2 + 1]["icon"],
                                    iconColor: summaryData[r * 2 + 1]["color"],
                                    isSelected: selectedIndex == (r * 2 + 1),
                                    onTap: () => setState(
                                        () => selectedIndex = r * 2 + 1),
                                  ),
                                )
                              else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),

                      const SizedBox(height: 10),

                      // PIE CHART: pass selectedKey + onSectionTap
                      DashboardPieChart(
                        data: {
                          for (var it in summaryData)
                            it["title"] as String:
                                (it["amount"] as num).toDouble()
                        },
                        selectedKey: summaryData[selectedIndex]["title"],
                        onSectionTap: (key) {
                          final idx =
                              summaryData.indexWhere((e) => e["title"] == key);
                          if (idx != -1) setState(() => selectedIndex = idx);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
