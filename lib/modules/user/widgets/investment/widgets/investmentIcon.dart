import 'package:flutter/material.dart';
import 'ViewInvestment.dart';
import 'add_edit_pages/edit_investment_page.dart';
import '/modules/user/widgets/investment/widgets/investment_models/Investment_model.dart';

class InvestmentActionButtons extends StatelessWidget {
  final Map<String, dynamic> investment;
  final int index;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final String token;

  const InvestmentActionButtons({
    super.key,
    required this.token,
    required this.investment,
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
                builder: (_) => ViewInvestment(investment: investment),
              ),
            );
            break;

          case 'edit':
            final updatedInvestment = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditInvestmentPage(
                  investment: InvestmentModel.fromJson(investment),
                  token: token,
                ),
              ),
            );
            if (updatedInvestment != null) {
              onUpdate(updatedInvestment);
              _showSnackBar(
                  context, 'Investment Updated Successfully!', Colors.green);
            }
            break;

          case 'delete':
            _confirmDelete(context);
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
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onDelete();
              _showSnackBar(context, 'Investment Deleted Successfully!',
                  Colors.orangeAccent);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
