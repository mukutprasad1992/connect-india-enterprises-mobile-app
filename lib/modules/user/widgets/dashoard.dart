import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Map<String, dynamic>>> futureServices;

  @override
  void initState() {
    super.initState();
    futureServices = fetchServiceData();
  }

  Future<List<Map<String, dynamic>>> fetchServiceData() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {"title": "Investment", "icon": Icons.currency_rupee, "services": 5, "amount": 10185.00},
      {"title": "Policy", "icon": Icons.policy, "services": 5, "amount": 1486.00},
      {"title": "Insurance", "icon": Icons.groups, "services": 6, "amount": 15078.00},
      {"title": "Loan", "icon": Icons.account_balance, "services": 6, "amount": 2283.00},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }
          final services = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Service Grid Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth > 900) {
                      crossAxisCount = 4;
                    } else if (constraints.maxWidth > 600) {
                      crossAxisCount = 3;
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return Card(
                          elevation: 4,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(service['icon'], size: 30, color: Colors.blue),
                                const SizedBox(height: 10),
                                Text(service['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("Total service: ${service['services']}"),
                                Text("Amount: ₹${service['amount'].toStringAsFixed(2)}"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // PIE CHART SECTION
                const Text("Pie Chart Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 700;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPieCard(
                          title: "Total Amount by Category",
                          sections: getAmountPieData(services),
                          legends: services.map((s) => {"title": s['title'], "color": getColor(s['title'])}).toList(),
                        ),
                        const SizedBox(height: 20),
                        _buildPieCard(
                          title: "Number of Services by Category",
                          sections: getServicePieData(services),
                          legends: services.map((s) => {
                                "title": "${s['title']}: ${s['services']}",
                                "color": getColor(s['title'])
                              }).toList(),
                        ),
                      ],
                    );
                  },
                ),
                
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPieCard({required String title, required List<PieChartSectionData> sections, required List<Map<String, dynamic>> legends}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              width: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: legends
                  .map((legend) => Row(
                        children: [
                          Container(width: 16, height: 16, color: legend['color'], margin: const EdgeInsets.only(right: 8)),
                          Text(legend['title'], style: const TextStyle(fontSize: 14)),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getAmountPieData(List<Map<String, dynamic>> services) {
    services.fold(0.0, (sum, item) => sum + item['amount']);
    return services.map((s) {
      return PieChartSectionData(
        value: s['amount'],
        title: s['title'],
        color: getColor(s['title']),
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  List<PieChartSectionData> getServicePieData(List<Map<String, dynamic>> services) {
    return services.map((s) {
      return PieChartSectionData(
        value: s['services'].toDouble(),
        title: "${s['title']}: ${s['services']}",
        color: getColor(s['title']),
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();
  }

  Color getColor(String category) {
    switch (category) {
      case "Investment":
        return Colors.blue;
      case "Policy":
        return Colors.green;
      case "Insurance":
        return Colors.lightGreen;
      case "Loan":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
