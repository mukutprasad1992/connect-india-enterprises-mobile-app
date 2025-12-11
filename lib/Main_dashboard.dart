import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/models/dashboard_model.dart';
import 'package:myapp/services/dashboard_api.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Selected tab index
  int selectedIndex = 0;
  bool isLoading = true;
  //List<Map<String, dynamic>> summaryData = [];

  // COLORS FOR INACTIVE TABS
  final List<Color> tabColors = [
    const Color(0xFF42A5F5),
    const Color(0xFF66BB6A),
    const Color(0xFF26A69A),
    const Color(0xFFEF5350),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   fetchDashboardData();
  // }

  // // Summary card dynamic data

  // Future<void> fetchDashboardData() async {
  //   setState(() => isLoading = true);

  //   try {
  //     final response = await getTotalAmount.getTotalAmountAndServiecsByUserIdServiceType();
  //     final serviceTypeData = ServiceTypeData.fromJson(response["data"]);

  //     setState(() {
  //       summaryData = [
  //         {
  //           'title': 'Total Investment',
  //           'count': int.parse(serviceTypeData.investment.totalServices),
  //           'amount': serviceTypeData.investment.totalAmount,
  //           'percent': 0,
  //           'monthlyChange': 0,
  //           "icon": Icons.bar_chart,
  //         },
  //         {
  //           'title': 'Total Policy',
  //           'count': int.parse(serviceTypeData.policy.totalServices),
  //           'amount': serviceTypeData.policy.totalAmount,
  //           'percent': 0,
  //           'monthlyChange': 0,
  //           "icon": Icons.description,
  //         },
  //         {
  //           'title': 'Total Insurance',
  //           'count': int.parse(serviceTypeData.insurance.totalServices),
  //           'amount': serviceTypeData.insurance.totalAmount,
  //           'percent': 0,
  //           'monthlyChange': 0,
  //           "icon": Icons.shield,
  //         },
  //         {
  //           'title': 'Total Loan',
  //           'count': int.parse(serviceTypeData.loan.totalServices),
  //           'amount': serviceTypeData.loan.totalAmount,
  //           'percent': 0,
  //           'monthlyChange': 0,
  //           "icon": Icons.credit_card,
  //         },
  //       ];
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error loading dashboard: $e")),
  //     );
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  // Summary card static data

  final List<Map<String, dynamic>> summaryData = [
    {
      "title": "Total Investment",
      "count": 25,
      "amount": 45000,
      "percentage": 12,
      "monthlyChange": 1200,
      "icon": Icons.bar_chart,
    },
    {
      "title": "Total Policy",
      "count": 15,
      "amount": 22500,
      "percentage": -3,
      "monthlyChange": -600,
      "icon": Icons.description,
    },
    {
      "title": "Total Insurance",
      "count": 10,
      "amount": 18000,
      "percentage": 5,
      "monthlyChange": 900,
      "icon": Icons.shield,
    },
    {
      "title": "Total Loan",
      "count": 12,
      "amount": 33900,
      "percentage": 8,
      "monthlyChange": 1800,
      "icon": Icons.credit_card,
    },
  ];

  // Tabs Label & Icons
  final List<Map<String, dynamic>> tabs = [
    {"label": "Investment", "icon": Icons.bar_chart},
    {"label": "Policy", "icon": Icons.description},
    {"label": "Insurance", "icon": Icons.shield},
    {"label": "Loan", "icon": Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            //      SCROLL TABS
            // =====================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final bool isActive = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF155CB0) // ACTIVE COLOR
                              : tabColors[index],
                          borderRadius: BorderRadius.circular(12),
                          border: isActive
                              ? null
                              : Border.all(color: Colors.grey.shade300),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF155CB0)
                                        .withOpacity(0.28),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              tabs[index]["icon"],
                              size: 16,
                              color: Colors
                                  .white, // both active and inactive → white
                            ),
                            const SizedBox(width: 6),
                            Text(
                              tabs[index]["label"],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            //     SUMMARY CARD (Dynamic)
            // ==============================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SummaryCard(
                title: summaryData[selectedIndex]["title"],
                totalCount: summaryData[selectedIndex]["count"],
                amount: summaryData[selectedIndex]["amount"],
                percentage:
                    (summaryData[selectedIndex]["percentage"]).toDouble(),
                monthlyChange: summaryData[selectedIndex]["monthlyChange"],
                changeColor: summaryData[selectedIndex]["percentage"] >= 0
                    ? Colors.green
                    : Colors.red,
                changeIcon: summaryData[selectedIndex]["percentage"] >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
              ),
            ),

            const SizedBox(height: 20),

            //        GRID STAT CARDS
            // ==============================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // ------ GRID ROW 1 ------
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Policy',
                              subtitle: '₹ 22,500',
                              value: '₹ 22.5k',
                              icon: Icons.description,
                              iconColor: const Color(0xFF3B82F6),
                              badge: '▼ 3%',
                              //bgColor: Color(0xFFE3F2FD),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Insurance',
                              subtitle: '₹ 18,000',
                              value: '₹ 18k',
                              icon: Icons.shield,
                              iconColor: const Color(0xFF2DD4BF),
                              badge: '▼ 3%',
                              //bgColor: Color(0xFFE8F5E9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ------ GRID ROW 2 ------
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Loan',
                              subtitle: '₹ 33,900',
                              value: '₹ 33.9k',
                              icon: Icons.credit_card,
                              iconColor: const Color(0xFF1E40AF),
                              //bgColor: Color(0xFFFFF3E0),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Investment',
                              subtitle: '₹ 45,000',
                              value: '₹ 45k',
                              icon: Icons.bar_chart,
                              iconColor: const Color(0xFFF87171),
                              //bgColor: Color(0xFFF3E5F5),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      //  FINAL PIE CHART IN BOTTOM
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DashboardPieChart(
                          data: {
                            "Investment":
                                summaryData[selectedIndex]["amount"].toDouble(),
                            "Policy": 22500,
                            "Insurance": 18000,
                            "Loan": 33900,
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
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

  //       Card Style
  // --------------------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  //     STAT CARD TEMPLATE
  // ===========================
  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color iconColor,
    String? badge,
    //Color? bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      //color: bgColor ?? Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

//         SUMMARY CARD
// ===============================
class SummaryCard extends StatelessWidget {
  final String title;
  final int totalCount;
  final int amount;
  final double percentage;
  final int monthlyChange;
  final Color changeColor;
  final IconData changeIcon;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.totalCount,
    required this.amount,
    required this.percentage,
    required this.monthlyChange,
    required this.changeColor,
    required this.changeIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final positive = percentage >= 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title ($totalCount)',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 8),

          // Amount + % change
          Row(
            children: [
              Text(
                '₹$amount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(changeIcon, size: 14, color: changeColor),
                    const SizedBox(width: 4),
                    Text(
                      '${positive ? '+' : ''}${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            monthlyChange >= 0
                ? 'You made an extra ₹${monthlyChange.abs()} this month'
                : 'You lost ₹${monthlyChange.abs()} this month',
            style: TextStyle(
              fontSize: 12,
              color: monthlyChange >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

//        PIE CHART WIDGET
// ===============================
class DashboardPieChart extends StatelessWidget {
  final Map<String, double> data;

  const DashboardPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (sum, item) => sum + item);

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
          const Text(
            "Summary Breakdown",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // ===== PIE CHART =====
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                startDegreeOffset: -90,
                sections: _getSections(data),
              ),
            ),
          ),

          const SizedBox(height: 14),
          Text(
            "Total: ₹${total.toInt()}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }

  // Pie chart sections builder
  List<PieChartSectionData> _getSections(Map<String, double> data) {
    final colors = [
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFF26A69A),
      const Color(0xFFEF5350),
    ];

    int i = 0;

    return data.entries.map((e) {
      final section = PieChartSectionData(
        color: colors[i % colors.length],
        value: e.value,
        radius: 55,
        title: "${e.key}\n${e.value.toInt()}",
        titleStyle: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
      i++;
      return section;
    }).toList();
  }
}
