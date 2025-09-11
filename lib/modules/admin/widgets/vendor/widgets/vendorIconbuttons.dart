import 'package:flutter/material.dart';
import 'edit_page.dart';
import 'vendordetailpage.dart';

class VendorActionButtons extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final Function(int index, Map<String, dynamic> updatedVendor) onUpdate;
  final Function(int index, Map<String, dynamic> updatedVendor) onBlockToggle;
  final void Function(int index) onDelete;

  const VendorActionButtons({
    super.key,
    required this.row,
    required this.index,
    required this.onUpdate,
    required this.onDelete,
    required this.onBlockToggle,
  });

  @override
  Widget build(BuildContext context) {
    //final isBlocked = row['Status'] == 'Blocked';
    return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.more_vert, color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8, // shadow effect
        color: Colors.white, // popup background color
        offset: const Offset(0, 40), // dropdown position
        onSelected: (value) async {
          if (value == 'edit') {
            final updatedVendor = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPage(vendor: row),
              ),
            );
            if (updatedVendor != null && updatedVendor is Map<String, String>) {
              onUpdate(index, updatedVendor);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vendor Updated Successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else if (value == 'delete') {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to delete this vendor?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onDelete(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vendor Deleted Successfully!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (value == 'block') {
            final isBlocked = row['Status'] == 'Blocked';
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(isBlocked ? 'Confirm Unblock' : 'Confirm Block'),
                content: Text(
                  isBlocked
                      ? 'Are you sure you want to unblock this vendor?'
                      : 'Are you sure you want to block this vendor?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      final updatedVendor = Map<String, String>.from(row);
                      updatedVendor['Status'] =
                          isBlocked ? 'Enable' : 'Blocked';
                      onBlockToggle(index, updatedVendor);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBlocked
                                ? 'Vendor Unblocked Successfully!'
                                : 'Vendor Blocked Successfully!',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              isBlocked ? Colors.green : Colors.redAccent,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: Text(isBlocked ? 'Unblock' : 'Block',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          } else if (value == 'view') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VendorDetailPage(row: row),
              ),
            );
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.amber, size: 20),
                    SizedBox(width: 5),
                    Text('Edit', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(
                      row['Status'] == 'Blocked'
                          ? Icons.block
                          : Icons.check_circle,
                      color: row['Status'] == 'Blocked'
                          ? Colors.red
                          : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      row['Status'] == 'Blocked' ? 'Blocked' : 'Enable',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 5),
                    Text('Delete', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: const [
                    Icon(Icons.visibility, color: Colors.blue, size: 20),
                    SizedBox(width: 5),
                    Text('View', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ]);
  }
}
