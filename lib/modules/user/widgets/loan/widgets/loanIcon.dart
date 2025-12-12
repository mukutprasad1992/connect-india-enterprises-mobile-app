import 'package:flutter/material.dart';
import 'Viewloan.dart';
import 'add_edit_pages/edit_loan_page.dart';
import '/models/loanModel.dart';
import '/services/user_module_service_Api/loanServices/deleteLoan.dart';

class LoanActionButtons extends StatelessWidget {
  final Map<String, dynamic> loan;
  final int index;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final String token;
  final Future<void> Function()? onReloadParent;

  const LoanActionButtons({
    super.key,
    required this.token,
    required this.loan,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
    this.onReloadParent,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      offset: const Offset(0, 40),
      onSelected: (value) async {
        switch (value) {
          case 'view':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewLoan(loan: loan),
              ),
            );
            break;

          case 'edit':
            try {
              final updatedLoan = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditLoanPage(
                      loan: LoanModel.fromJson(loan),
                      token: token,
                      onReloadParent: onReloadParent),
                ),
              );
              if (updatedLoan != null) {
                onUpdate(updatedLoan);
                _showSnackBar(
                  context,
                  'Loan Updated Successfully!',
                  Colors.green,
                );
              }
              if (onReloadParent != null) {
                // optional debug
                // print("Calling onReloadParent from InvestmentActionButtons after edit");
                await onReloadParent!();
              }
            }
            catch (e) {
              _showSnackBar(
                context,
                'Error while editing: ${e.toString()}',
                Colors.red,
              );
            }
            break;
          case 'delete':
            if (loan['id'] != null) {
              _confirmDelete(context);
            } else {
              _showSnackBar(
                context,
                'Invalid loan ID!',
                Colors.red,
              );
            }
            break;
        }
      },
      itemBuilder: (context) => [
        _menuItem('view', Icons.visibility, Colors.blue, 'View'),
        _menuItem('edit', Icons.edit, Colors.amber, 'Edit'),
        _menuItem('delete', Icons.delete, Colors.redAccent, 'Delete'),
      ],
    );
  }

  PopupMenuItem<String> _menuItem(
      String value, IconData icon, Color color, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this loan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteLoan(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLoan(BuildContext context) async {
    final id = loan['id']?.toString() ?? '';
    if (id.isEmpty) {
      _showSnackBar(context, 'Cannot delete: ID is missing', Colors.red);
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: const [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Expanded(child: Text("Deleting...")),
          ],
        ),
      ),
    );
    try {
      final result = await deleteLoanApi.DeleteLoanById(
        token: token,
        id: id,
      );

      Navigator.of(context).pop();

      if (result["status"] == true) {
        onDelete();
        _showSnackBar(
          context,
          result["message"] ?? 'Loan Deleted Successfully!',
          Colors.green,
        );
      } else {
        _showSnackBar(
          context,
          result["message"] ?? 'Failed to delete loan',
          Colors.redAccent,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showSnackBar(
        context,
        "Error deleting loan: $e",
        Colors.red,
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }
}
