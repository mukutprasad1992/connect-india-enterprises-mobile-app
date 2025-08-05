import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardOverview extends StatefulWidget {
  @override
  _DashboardOverviewState createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  final List<Map<String, dynamic>> summaryData = [
    {
      'title': 'Total Investment',
      'count': 3,
      'amount': 400,
      'percent': -67,
      'monthlyChange': -200
    },
    {
      'title': 'Total Policy',
      'count': 2,
      'amount': 300,
      'percent': 100,
      'monthlyChange': 100
    },
    {
      'title': 'Total Insurance',
      'count': 3,
      'amount': 500,
      'percent': 50,
      'monthlyChange': 100
    },
    {
      'title': 'Total Loan',
      'count': 4,
      'amount': 500,
      'percent': -33,
      'monthlyChange': -100
    },
  ];

  int _itemCount = 3;
  double _radius = 60;

  final List<String> chart1Labels = [
    'Investment',
    'Policy',
    'Loan',
    'Insurance'
  ];
  final List<Color> chart1Colors = [
    // Color(#42a5f5),
    // Color(#66bb6a),
    // Color(#26a69a),
    // Color(#ef5350),
    
   Color(0xFF42A5F5), // Investment
   Color(0xFF66BB6A), // Policy
   Color(0xFF26A69A), // Insurance
   Color(0xFFEF5350), // Loan
  ];

  final List<String> chart2Labels = ['Asset', 'Protection', 'Liability'];
  final List<Color> chart2Colors = [Color(0xFF42A5F5), Color(0xFF46B182), Color(0xFFEF5350)];

  List<PieChartSectionData> _generateChartData(
      List<String> labels, List<Color> colors, int count) {
    return List.generate(count, (index) {
      return PieChartSectionData(
        value: (index + 1) * 10,
        title: labels[index],
        color: colors[index],
        radius: _radius,
        titleStyle: const TextStyle(
            fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }

  Widget _buildLegend(List<String> labels, List<Color> colors, int count) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: List.generate(count, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: colors[index]),
            const SizedBox(width: 4),
            Text(labels[index], style: const TextStyle(fontSize: 14)),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900
        ? 3
        : width > 600
            ? 2
            : 1;

    final chart1Data =
        _generateChartData(chart1Labels, chart1Colors, _itemCount);
    final chart2Data = _generateChartData(
        chart2Labels, chart2Colors, _itemCount > 3 ? 3 : _itemCount);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: summaryData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final data = summaryData[index];
                    final isPositive = data['percent'] >= 0;
                    return SummaryCard(
                      title: data['title'],
                      totalCount: data['count'],
                      amount: data['amount'],
                      percentage: data['percent'].toDouble(),
                      monthlyChange: data['monthlyChange'],
                      changeColor: isPositive ? Colors.green : Colors.redAccent,
                      changeIcon:
                          isPositive ? Icons.trending_up : Icons.trending_down,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // First Pie Chart
                const Text("Total Amount by Category",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(PieChartData(
                      sections: chart1Data, centerSpaceRadius: 30)),
                ),
                _buildLegend(chart1Labels, chart1Colors, _itemCount),
                const SizedBox(height: 20),

                // Second Pie Chart
                const Text("Number of Services by Category",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(PieChartData(
                      sections: chart2Data, centerSpaceRadius: 30)),
                ),
                _buildLegend(chart2Labels, chart2Colors,
                    (_itemCount > 3 ? 3 : _itemCount)),

                const SizedBox(height: 20),

                // Slider for Item Count
                _buildSliderControl(
                  label: "Number of Items",
                  value: _itemCount.toDouble(),
                  min: 1,
                  max: 4,
                  divisions: 3,
                  onChanged: (val) {
                    setState(() {
                      _itemCount = val.toInt();
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Slider for Radius
                _buildSliderControl(
                  label: "Radius",
                  value: _radius,
                  min: 30,
                  max: 100,
                  divisions: 7,
                  onChanged: (val) {
                    setState(() {
                      _radius = val;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderControl({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ${value.toInt()}",
          style: const TextStyle(fontWeight: FontWeight.w500)),
        SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.blue,         // filled track
          inactiveTrackColor: Colors.indigo.shade100, // unfilled track
          //thumbColor: Colors.deepOrange,           // slider knob
          //overlayColor: Colors.deepOrange.withOpacity(0.2), // ripple
          //valueIndicatorColor: Colors.black,       // label bubble
          //thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          //overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
      )
        
      ],
    );
  }
}

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
              offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title ($totalCount)',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('₹$amount',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (monthlyChange >= 0)
            Text(
              'You made an extra ₹${monthlyChange.abs()} this month',
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            )
          else
            Text(
              'You lost ₹${monthlyChange.abs()} this month',
              style: const TextStyle(
                  fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}
