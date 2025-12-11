import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardCardsPage extends StatefulWidget {
  const DashboardCardsPage({Key? key}) : super(key: key);

  @override
  State<DashboardCardsPage> createState() => _DashboardCardsPageState();
}

class _DashboardCardsPageState extends State<DashboardCardsPage> {
  int totalUsers = 50;

  final Map<String, String> _selectedRange = {
    'Investment': '1M',
    'Policy': '1M',
    'Insurance': '1M',
    'Loan': '1M',
  };

  // Totals for each category per range (sample totals). Replace with API response.
  final Map<String, Map<String, double>> _sampleData = {
    'Investment': {'1M': 12000, '3M': 36000, '6M': 72000, '1Y': 140000},
    'Policy': {'1M': 8000, '3M': 24000, '6M': 48000, '1Y': 96000},
    'Insurance': {'1M': 6000, '3M': 18000, '6M': 36000, '1Y': 72000},
    'Loan': {'1M': 15000, '3M': 45000, '6M': 90000, '1Y': 180000},
  };

  final List<String> _ranges = ['1M', '3M', '6M', '1Y'];

  // UI state for selected metric to show in the line chart
  String _activeMetricForChart = 'Investment';

  // Global selected range (the row under Total Users)
  String _globalRange = '1M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTotalUsersCard(),
              const SizedBox(height: 8),

              // Row of global range buttons under Total Users
              _buildGlobalRangeRow(),

              const SizedBox(height: 12),

              // Grid of four cards + charts below
              SizedBox(
                height: 300,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 2,
                  children: [
                    _buildMetricCard('Investment', Icons.bar_chart),
                    _buildMetricCard('Policy', Icons.description),
                    _buildMetricCard('Insurance', Icons.shield),
                    _buildMetricCard('Loan', Icons.credit_card),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Pie chart and Line chart
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildPieChartCard(),
                      const SizedBox(height: 12),
                      _buildLineChartCard(),
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

  Widget _buildTotalUsersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Users',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                totalUsers.toString(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              const SizedBox(height: 2),
              const Text(
                'Active users using the app',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalRangeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _ranges.map((r) {
        final active = _globalRange == r;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: active ? Colors.indigo : Colors.white,
                foregroundColor: active ? Colors.white : Colors.black87,
                elevation: active ? 4 : 0,
                side: BorderSide(color: active ? Colors.indigo : Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onPressed: () {
                // when pressing a global range button, update every card's selected range
                setState(() {
                  _globalRange = r;
                  _selectedRange.updateAll((key, value) => r);
                  // also set active chart metric to keep charts in sync
                  _activeMetricForChart = _activeMetricForChart;
                });
              },
              child: Text(r, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricCard(String title, IconData icon) {
  final selected = _selectedRange[title]!;
  final value = _sampleData[title]?[selected] ?? 0;

  return GestureDetector(
    onTap: () {
      // When tapping a card, set it as active chart metric
      setState(() => _activeMetricForChart = title);
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row (now without dropdown)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: Colors.indigo),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 12),

          Text('₹${_formatNumber(value)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          //const SizedBox(height: 6),
          //Text('${selected} summary for $title', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          //const Spacer(),
          //Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: () {}, child: const Text('View'))])
        ],
      ),
    ),
  );
}


  Widget _buildPieChartCard() {
    // Build pie sections from currently selected ranges for each metric.
    final entries = _sampleData.entries.map((e) {
      final range = _selectedRange[e.key]!;
      final value = e.value[range] ?? 0;
      return MapEntry(e.key, value);
    }).toList();

    final sections = List.generate(entries.length, (i) {
      final key = entries[i].key;
      final value = entries[i].value;
      final colors = [Color(0xFF42A5F5), Color(0xFF66BB6A), Color(0xFF26A69A), Color(0xFFEF5350)];
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: '${key}₹${_formatNumber(value)}',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });

    final total = entries.fold(0.0, (s, e) => s + e.value);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Distribution (based on selected ranges)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(height: 180, child: PieChart(PieChartData(sectionsSpace: 4, centerSpaceRadius: 40, sections: sections))),
        const SizedBox(height: 8),
        Text('Total: ₹${_formatNumber(total)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.indigo)),
      ]),
    );
  }

  Widget _buildLineChartCard() {
    // build time series for _activeMetricForChart based on its selected range
    final metric = _activeMetricForChart;
    final range = _selectedRange[metric]!;
    final series = _getTimeSeriesFor(metric, range);
    final labels = _labelsForRange(range);

    final spots = List.generate(series.length, (i) => FlSpot(i.toDouble(), series[i]));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$metric — $range', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          TextButton(onPressed: () => _showChangeMetricDialog(), child: const Text('Change'))
        ]),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (spots.isEmpty) ? 1 : (spots.length - 1).toDouble(),
              minY: 0,
              maxY: (series.isEmpty) ? 1 : (series.reduce((a, b) => a > b ? a : b) * 1.2),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, meta) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                  return Text(labels[idx], style: const TextStyle(fontSize: 10));
                })),
              ),
              gridData: FlGridData(show: true),
              lineBarsData: [
                LineChartBarData(spots: spots, isCurved: true, barWidth: 3, dotData: FlDotData(show: true)),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _showChangeMetricDialog() {
    showModalBottomSheet(context: context, builder: (ctx) {
      return ListView(
        shrinkWrap: true,
        children: _sampleData.keys.map((k) => ListTile(
          title: Text(k),
          onTap: () {
            setState(() => _activeMetricForChart = k);
            Navigator.pop(ctx);
          },
        )).toList(),
      );
    });
  }

  // Generate a time series for the metric: number of months equals range months
  // This is synthetic: it creates monthly numbers that sum approximately to the total.
  List<double> _getTimeSeriesFor(String metric, String range) {
    final total = _sampleData[metric]?[range] ?? 0.0;
    final months = _monthsForRange(range);
    if (months == 0) return [];

    // Simple distribution: start lower and increase, keeping sum near total
    final List<double> values = List.generate(months, (i) {
      final factor = 0.6 + (i / (months - 1 + 0.00001)) * 1.4; // between 0.6 and 2.0
      return factor;
    });

    final sumFactors = values.reduce((a, b) => a + b);
    final scale = total / sumFactors;
    return values.map((f) => double.parse((f * scale).toStringAsFixed(2))).toList();
  }

  List<String> _labelsForRange(String range) {
    final months = _monthsForRange(range);
    final now = DateTime.now();
    final labels = <String>[];
    for (int i = months - 1; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      labels.add('${d.month}/${d.year.toString().substring(2)}');
    }
    return labels;
  }

  int _monthsForRange(String range) {
    switch (range) {
      case '1M':
        return 1;
      case '3M':
        return 3;
      case '6M':
        return 6;
      case '1Y':
        return 12;
      default:
        return 1;
    }
  }

  String _formatNumber(double n) {
    if (n >= 10000000) return '${(n / 10000000).toStringAsFixed(1)} Cr';
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)} L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toStringAsFixed(0);
  }
}
