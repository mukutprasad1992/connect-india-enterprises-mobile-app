import 'package:flutter/material.dart';
import 'vendorCustomerdetails.dart';
import 'add_edit_Customer.dart';


class CustomerActionButtons extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final void Function(int, Map<String, dynamic>) onUpdate;

  const CustomerActionButtons({
    super.key,
    required this.row,
    required this.index,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'edit') {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewVendorCustomerPage(
                mode: "edit",
                vendorCustomerModel: row,
                vendorId: row['id']?.toString(),
                onCompleted: (dbId) {},
              ),
            ),
          );
          if (updated != null) onUpdate(index, row);
        } else if (value == 'view') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VendorDetailPage(row: row)),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.amber, size: 18),
              SizedBox(width: 5),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, color: Colors.blue, size: 18),
              SizedBox(width: 5),
              Text('View'),
            ],
          ),
        ),
      ],
    );
  }
}

