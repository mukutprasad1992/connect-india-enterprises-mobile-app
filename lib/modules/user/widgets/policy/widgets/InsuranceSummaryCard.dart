import 'package:flutter/material.dart';
import 'insuranceIcon.dart';

class InsuranceSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final String token;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onDelete;

  const InsuranceSummaryCard({
    super.key,
    required this.token,
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
  });

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Pending":
        return Icons.hourglass_empty; // ⏳
      case "In Progress":
        return Icons.autorenew; // 🔄
      case "Approved":
        return Icons.check_circle; // ✅
      case "Rejected":
        return Icons.cancel; // ❌
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.blue;
      case "In Progress":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 280;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Occupation + Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(Icons.work,
                                size: 14, color: Colors.black),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                row['occupation'] ?? 'No Occupation',
                                style: TextStyle(
                                  fontSize: isWide ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InsuranceActionButtons(
                        token: token,
                        insurance: row,
                        index: index,
                        onUpdate: onUpdate,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  /// Aadhaar
                  _buildInfoChip("Aadhaar", row['aadharNumber'] ?? '',
                      Icons.credit_card, Colors.deepOrange),
                  const SizedBox(height: 4),

                  /// PAN
                  _buildInfoChip("PAN", row['panNumber'] ?? '', Icons.badge,
                      Colors.indigo),
                  const SizedBox(height: 6),
                  /// Status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(row['status'] ?? '').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(row['status'] ?? ''),
                          size: 14,
                          color: _getStatusColor(row['status'] ?? ''),
                        ),
                        const SizedBox(width: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Status: ",
                                style: TextStyle(
                                  color: Colors.black, // Label black
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: row['status'] ?? '',
                                style: TextStyle(
                                  color: _getStatusColor(
                                      row['status'] ?? ''), // Value color
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Custom chip with label black and value colored
  Widget _buildInfoChip(
      String label, String value, IconData icon, Color valueColor) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 14), // smaller size
        const SizedBox(width: 6),
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12, // reduced size
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor, 
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // reduced size
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
