
import 'package:flutter/material.dart';
import 'inquery_details.dart';
import '/models/inquiryModel.dart';
import '/services/admin_module_service_Api/Inquiry/inqueryStatusApi.dart';

class InquiryActionButtons extends StatelessWidget {
  final InquiryModel row;
  final VoidCallback onStatusChanged;
  final Function(bool isLoading)? setLoading;

  const InquiryActionButtons({
    super.key,
    this.setLoading,
    required this.row,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status = (row.status ?? '').toLowerCase().trim();

    final isPending = status == 'pending';
    final isInProgress = status == 'in progress';
    final isApproved = status == 'approved';
    final isRejected = status == 'rejected';
    final isFinal = isApproved || isRejected;

    // ✅ If the form has an unexpected or empty status → mark incomplete
    final isIncomplete = !['pending', 'in progress', 'approved', 'rejected'].contains(status);

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
            MaterialPageRoute(builder: (_) => InqueryDetails(row: row)),
          );
          return;
        }

        // ⚠️ Warn if user form incomplete
        if (isIncomplete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "This user's form is incomplete. Please ask the user to complete their form before updating the status.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
          return;
        }

        // ✅ Handle valid status updates
        if (value == 'toggle' && isPending) {
          _showConfirmationDialog(
            context,
            'Confirm Mark as In Progress',
            'Are you sure you want to mark this inquiry as In Progress?',
            () => _updateStatus(context, 'In Progress'),
          );
        } else if (value == 'approve') {
          _showConfirmationDialog(
            context,
            'Confirm Approval',
            'Are you sure you want to approve this inquiry?',
            () => _updateStatus(context, 'Approved'),
          );
        } else if (value == 'reject') {
          _showConfirmationDialog(
            context,
            'Confirm Rejection',
            'Are you sure you want to reject this inquiry?',
            () => _updateStatus(context, 'Rejected'),
          );
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[
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
        ];

        // Only show update options if not Approved or Rejected
        if (!isFinal) {
          if (isPending) {
            items.add(
              PopupMenuItem(
                value: 'toggle',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.refresh, color: Colors.blue, size: 20),
                    SizedBox(width: 5),
                    Text('In Progress', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            );
          }

          if (isPending || isInProgress) {
            items.addAll([
              PopupMenuItem(
                value: 'approve',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 5),
                    Text('Approve', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reject',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                    SizedBox(width: 5),
                    Text('Reject', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ]);
          }
        }

        return items;
      },
    );
  }

  // ✅ Safe confirmation dialog
  void _showConfirmationDialog(BuildContext context, String title,
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

  // ✅ Safe async call (no context after dispose)
  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    final rootContext =
        Navigator.of(context, rootNavigator: true).context; // ✅ safe context
    try {
      setLoading?.call(true);

      final response = await InquiryService.UpdateAllStatus(
        serviceId: row.serviceId ?? '',
        id: row.id.toString(),
        status: newStatus,
      );

      setLoading?.call(false);

      if (response['status'] == true) {
        onStatusChanged();
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(
            content: Text(
              'Status updated to ${response['data']['status']} successfully ',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to update status'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      setLoading?.call(false);
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
