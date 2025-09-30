import 'package:flutter/material.dart';
import 'inquery_details.dart';
import 'InquiryModel/inquirymodel.dart';
import '/services/adminServiceApi/inqueryStatusApi.dart';

class InquiryActionButtons extends StatelessWidget {
  final InquiryModel row;
  final VoidCallback onStatusChanged;
  final String token; 

  const InquiryActionButtons({
    super.key,
    required this.row,
    required this.onStatusChanged,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final status = row.status.toLowerCase();
    final isPendingOrInProgress = status == 'pending' || status == 'in progress';

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.white,
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
          final newStatus = status == 'in progress' ? 'Pending' : 'In Progress';
          _showConfirmationDialog(
            context,
            'Change Status',
            'Do you want to mark this inquiry as $newStatus?',
            () => _updateStatus(context, newStatus),
          );
        } else if (value == 'approve') {
          _showConfirmationDialog(
            context,
            'Approve Inquiry',
            'Are you sure you want to approve this inquiry?',
            () => _updateStatus(context, 'Approved'),
          );
        } else if (value == 'reject') {
          _showConfirmationDialog(
            context,
            'Reject Inquiry',
            'Are you sure you want to reject this inquiry?',
            () => _updateStatus(context, 'Rejected'),
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
              Text('View', style: TextStyle(fontSize: 15)),
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
                  status == 'in progress' ? Icons.hourglass_top : Icons.refresh,
                  size: 20,
                  color: status == 'pending'
                      ? Colors.blue
                      : status == 'in progress'
                          ? Colors.orange
                          : Colors.grey,
                ),
                const SizedBox(width: 5),
                Text(
                  status == 'in progress'
                      ? 'Back to Pending'
                      : 'Mark In Progress',
                  style: const TextStyle(fontSize: 15),
                ),
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
                Text('Approve', style: TextStyle(fontSize: 15)),
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
                Text('Reject', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
      ],
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title,
      String content, VoidCallback onConfirm) {
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
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    try {
      final response = await ServiceTypeApi.UpdateStatus(
        token: token,
        serviceId: row.serviceId,
        id: row.id.toString(),
        status: newStatus,
      );

      if (response['status'] == true) {
        row.status = response['data']['status'];
        onStatusChanged();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Inquiry updated to ${response['data']['status']} successfully!',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to update status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
