import 'package:flutter/material.dart';
import 'inquery_details.dart';

class InquiryActionButtons extends StatelessWidget {
  final Map<String, String> row;
  final VoidCallback onStatusChanged;

  const InquiryActionButtons({
    super.key,
    required this.row,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status = (row['Status'] ?? 'Pending').toLowerCase();
    final isPendingOrInProgress = status == 'pending' || status == 'in progress';

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
      elevation: 8, // shadow effect
      color: Colors.white, // popup background color
      offset: const Offset(0, 40),

      onSelected: (value) {
        if (value == 'view') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InqueryDetails(row: row),
            ),
          );
        } else if (value == 'toggle') {
          final newStatus = status == 'in progress' ? 'Pending' : 'In progress';
          _showConfirmationDialog(
            context,
            'Change Status',
            'Do you want to mark this inquiry as $newStatus?',
            () {
              row['Status'] = newStatus;
              onStatusChanged();
              final backgroundColor = newStatus.toLowerCase() == 'in progress'
                  ? Colors.orange
                  : Colors.redAccent;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Inquiry marked as $newStatus',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: backgroundColor,
                ),
              );
            },
          );
        } else if (value == 'approve') {
          _showConfirmationDialog(
            context,
            'Approve Inquiry',
            'Are you sure you want to approve this inquiry?',
            () {
              row['Status'] = 'Approved';
              onStatusChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Inquiry Approved Successfully!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        } else if (value == 'reject') {
          _showConfirmationDialog(
            context,
            'Reject Inquiry',
            'Are you sure you want to reject this inquiry?',
            () {
              row['Status'] = 'Rejected';
              onStatusChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Inquiry Rejected Successfully!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: const [
              Icon(Icons.visibility, color: Colors.blue, size: 20),
              SizedBox(width: 5),
              Text('View',style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        if (isPendingOrInProgress)
          PopupMenuItem(
            value: 'toggle',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  status == 'in progress' ? Icons.hourglass_top : Icons.refresh,size: 20,
                  color: status == 'pending'
                      ? Colors.blue
                      : status == 'in progress'
                          ? Colors.orange
                          : Colors.grey,
                  
                ),
                const SizedBox(width: 5),
                Text(status == 'in progress' ? 'Back to Pending' : 'Mark In Progress',style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        if (isPendingOrInProgress)
          PopupMenuItem(
            value: 'approve',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 5),
                Text('Approve',style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        if (isPendingOrInProgress)
          PopupMenuItem(
            value: 'reject',
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: const [
                Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                SizedBox(width: 5),
                Text('Reject',style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
      ],
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
