import 'package:flutter/material.dart';
import 'voucherdetailspage.dart';
import 'editpage.dart';

class VoucherActionButtons extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onBlockToggle;
  final ValueChanged<Map<String, dynamic>> onUpdate;

  const VoucherActionButtons({
    super.key,
    required this.row,
    required this.index,
    required this.onDelete,
    required this.onBlockToggle,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
      elevation: 8, // shadow effect
      color: Colors.white, // popup background color
      offset: const Offset(0, 40), // dropdown position
      onSelected: (value) async {
        if (value == 'view') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VoucherDetailPage(row: row)),
          );
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content:
                    const Text('Are you sure you want to delete this voucher?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onDelete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher Deleted Successfully!'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else if (value == 'redeem') {
          bool isRedeemed = row['Redeemed'] == 'true';

          if (isRedeemed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This voucher is already redeemed!'),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }

          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Confirm Redeem'),
                content: const Text('Do you want to redeem this voucher?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: const Text('Redeem',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Map<String, String> updated = Map.from(row);
                      updated['Redeemed'] = 'true';
                      onUpdate(updated);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voucher Redeemed Successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else if (value == 'edit') {
          final updatedVoucher = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VoucherEditgeneratePage(voucher: row)),
          );
          if (updatedVoucher != null) {
            onUpdate(updatedVoucher);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Voucher Updated Successfully!'),
                duration: Duration(seconds: 1),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: const [
              Icon(Icons.visibility, color: Colors.blue,size: 20,),
              SizedBox(width: 5),
              Text('View', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.redAccent,size: 20),
              SizedBox(width: 5),
              Text('Delete', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'redeem',
          child: Row(
            children: [
              Icon(
                row['Redeemed'] == 'true' ? Icons.block : Icons.card_giftcard,size: 20,
                color: row['Redeemed'] == 'true'
                    ? Colors.redAccent
                    : Colors.deepPurple,
              ),
              const SizedBox(width: 5),
              Text(row['Redeemed'] == 'true' ? 'Already Redeemed' : 'Redeem', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        if (row['Redeemed'] != 'true')
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: const [
                Icon(Icons.edit, color: Colors.amberAccent,size: 20),
                SizedBox(width: 5),
                Text('Edit', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
      ],
    );
  }
}
