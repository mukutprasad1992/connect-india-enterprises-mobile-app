import 'package:flutter/material.dart';
import 'ViewInvestment.dart';
import 'add_edit_pages/edit_investment_page.dart';
import '/models/investmentModel.dart';
import '../../../../../services/user_module_service_Api/investmentServices/deleteServiceTypeApi.dart';

class InvestmentActionButtons extends StatelessWidget {
  final Map<String, dynamic> investment;
  final int index;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final String token;
  //final VoidCallback? onReloadParent;
  final Future<void> Function()? onReloadParent;

  const InvestmentActionButtons({
    super.key,
    required this.token,
    required this.investment,
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
                builder: (_) => ViewInvestment(investment: investment),
              ),
            );
            break;

          // case 'edit':
          //   if (investment is Map<String, dynamic>)
          //   {
          //     final updatedInvestment = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => EditInvestmentPage(
          //           investment: InvestmentModel.fromJson(investment),
          //           token: token,
          //           onReloadParent: onReloadParent,
          //         ),
          //       ),
          //     );
          //     if (updatedInvestment != null) {
          //       onUpdate(updatedInvestment);
          //       _showSnackBar(
          //         context,
          //         'Investment Updated Successfully!',
          //         Colors.green,
          //       );
          //     }

          //   }
          //   else {
          //     _showSnackBar(
          //       context,
          //       'Invalid investment data received.',
          //       Colors.red,
          //     );
          //   }
          //   break;

          case 'edit':
            try {
              // Wait for edit page result (it should return updated Map on successful save)
              final Map<String, dynamic>? updatedInvestment =
                await Navigator.push<Map<String, dynamic>?>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditInvestmentPage(
                    investment: InvestmentModel.fromJson(investment),
                    token: token,
                    onReloadParent:onReloadParent, 
                  ),
                ),
              );

              // If edit returned updated data, update local item immediately
              if (updatedInvestment != null) {
                onUpdate(updatedInvestment);
                _showSnackBar(
                  context,
                  'Investment Updated Successfully!',
                  Colors.green,
                );
              }

              // ALWAYS attempt to reload parent from server to ensure fresh data.
              // This covers the case where user pressed Back without returning updated data.
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
            if (investment['id'] != null) {
              _confirmDelete(context);
            } else {
              _showSnackBar(
                context,
                'Invalid investment ID!',
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
        content: const Text('Are you sure you want to delete this investment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteInvestment(context); // <-- call here
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInvestment(BuildContext context) async {
    final id = investment['id']?.toString() ?? '';
    if (id.isEmpty) {
      _showSnackBar(context, 'Cannot delete: ID is missing', Colors.red);
      return;
    }

    // Show loader dialog
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
      final result = await ServiceTypeApi.DeleteServiceType(
        token: token,
        id: id,
      );

      Navigator.of(context).pop(); // Close the loader dialog

      if (result["status"] == true) {
        onDelete();
        _showSnackBar(
          context,
          result["message"] ?? 'Investment Deleted Successfully!',
          Colors.green,
        );
      } else {
        _showSnackBar(
          context,
          result["message"] ?? 'Failed to delete investment',
          Colors.redAccent,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showSnackBar(
        context,
        "Error deleting investment: $e",
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
