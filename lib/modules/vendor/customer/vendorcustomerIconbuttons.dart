import 'package:flutter/material.dart';
import 'editVendorCustomer.dart';
import 'vendorCustomerdetails.dart';

class VendorActionButtons extends StatelessWidget {
  final Map<String, String> row;
  final int index;
  final Function(int index, Map<String, String> updatedVendor) onUpdate;
  final Function(int index, Map<String, String> updatedVendor) onBlockToggle;

  const VendorActionButtons({
    super.key,
    required this.row,
    required this.index,
    required this.onUpdate,
    required this.onBlockToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isBlocked = row['Status'] == 'Blocked';

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
          tooltip: 'Edit Vendor',
          onPressed: () async {
            final updatedVendor = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPage(vendor: row),
              ),
            );
            if (updatedVendor != null && updatedVendor is Map<String, String>) {
              onUpdate(index, updatedVendor);
            }
          },
        ),
        IconButton(
          icon: Icon(
            isBlocked ? Icons.lock_open : Icons.block,
            color: isBlocked ? Colors.green : Colors.red,
            size: 20,
          ),
          tooltip: isBlocked ? 'Unblock Vendor' : 'Block Vendor',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo),
                      child: Text(
                        isBlocked ? 'Unblock' : 'Block',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        final updatedVendor = Map<String, String>.from(row);
                        updatedVendor['Status'] =
                            isBlocked ? 'Active' : 'Blocked';
                        onBlockToggle(index, updatedVendor);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isBlocked
                                  ? 'Vendor Unblocked'
                                  : 'Vendor Blocked',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                              isBlocked ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
          tooltip: 'View Vendor',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VendorDetailPage(row: row),
              ),
            );
          },
        ),
      ],
    );
  }
}
