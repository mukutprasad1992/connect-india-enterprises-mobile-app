
import 'package:flutter/material.dart';
import '/models/customerModel.dart';
import 'customerIconbuttons.dart';
class CustomerSummaryCard extends StatelessWidget {
  final CustomerModel row;
  final int index;
 
  const CustomerSummaryCard({
    super.key,
    required this.row,
    required this.index,
    
  });

  @override
  Widget build(BuildContext context) {
    // Prepare list of data items
    final dataItems = <Map<String, dynamic>>[
      {"label": "Phone", "value": row.phone, "icon": Icons.phone, "color": Colors.green},
      if (row.businessName?.isNotEmpty == true)
        {"label": "Business", "value": row.businessName!, "icon": Icons.business_center, "color": Colors.indigo},
      if (row.businessRepresentative?.isNotEmpty == true)
        {"label": "Representative", "value": row.businessRepresentative!, "icon": Icons.person_outline, "color": Colors.deepOrange},
      if (row.email?.isNotEmpty == true)
        {"label": "Email", "value": row.email!, "icon": Icons.email, "color": Colors.blue},
    ];

    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      row.name?.isNotEmpty == true ? row.name! : 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CustomerActionButtons(row: row, index: index),
                ],
              ),
              const SizedBox(height: 8),

              // Data items
              if (dataItems.isNotEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: dataItems.length == 1
                        ? MainAxisAlignment.center 
                        : MainAxisAlignment.spaceEvenly, 
                    children: dataItems.map((item) {
                      return _buildInfoChip(item['label'], item['value'], item['icon'], item['color']);
                    }).toList(),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData? icon, Color valueColor) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: Colors.black, size: 14),
        if (icon != null) const SizedBox(width: 6),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
