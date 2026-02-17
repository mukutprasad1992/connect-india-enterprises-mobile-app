import 'package:flutter/material.dart';
import 'ViewInsurance.dart';
import '/models/insuranceModel.dart';
import 'add_edit_pages/edit_insurance_page.dart';
import '/services/user_module_service_Api/insuranceServices/deleteInsurance.dart';

// isko updates karna hai isme abhi investment ki delete api call hai

class InsuranceActionButtons extends StatelessWidget {
  final Map<String, dynamic> insurance;
  final int index;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final String token;

  const InsuranceActionButtons({
    super.key,
    required this.token,
    required this.insurance,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
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
                builder: (_) => ViewInsurance(insurance: insurance),
              ),
            );
            break;

          case 'edit':
            // ignore: unnecessary_type_check
            if (insurance is Map<String, dynamic>) {
              final updatedInsurance = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditInsurancePage(
                    insurance: InsuranceModel.fromJson(insurance),
                    token: token,
                  ),
                ),
              );
              if (updatedInsurance != null) {
                onUpdate(updatedInsurance);
                _showSnackBar(
                  context,
                  'Insurance Updated Successfully!',
                  Colors.green,
                );
              }
            } else {
              _showSnackBar(
                context,
                'Invalid insurance data received.',
                Colors.red,
              );
            }
            break;
          case 'delete':
            if (insurance['id'] != null) {
              _confirmDelete(context);
            } else {
              _showSnackBar(
                context,
                'Invalid insurance ID!',
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
        content: const Text('Are you sure you want to delete this insurance?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteInsurance(context); // <-- call here
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInsurance(BuildContext context) async {
    final id = insurance['id']?.toString() ?? '';
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
      final result = await deleteInsuranceApi.DeleteInsuranceById(
        token: token,
        id: id,
      );

      Navigator.of(context).pop(); // Close loading dialog

      if (result["status"] == true) {
        onDelete();
        _showSnackBar(
          context,
          result["message"] ?? 'Insurance Deleted Successfully!',
          Colors.green,
        );
      } else {
        _showSnackBar(
          context,
          result["message"] ?? 'Failed to delete insurance',
          Colors.redAccent,
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); 
      _showSnackBar(
        context,
        "Error deleting insurance: $e",
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
