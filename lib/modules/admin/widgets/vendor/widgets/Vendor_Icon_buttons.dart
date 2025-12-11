import 'package:flutter/material.dart';
import 'vendor_detailpage.dart';
import 'add_edit_vendor.dart';
import '/services/admin_module_service_Api/vendor/updateStatusById.dart';

class VendorActionButtons extends StatefulWidget {
  final Map<String, dynamic> row;
  final Map<String, dynamic> vendor;
  final int index;
  final int id;
  final String status;
  final Function(int index, Map<String, dynamic> updatedVendor) onUpdate;
  final Function(int index, Map<String, dynamic> updatedVendor) onBlockToggle;
  final VoidCallback? onReloadParent;
  

  /// NEW: callback to show/hide loader in parent
  final Function(bool isLoading)? setLoading;

  const VendorActionButtons({
    super.key,
    required this.row,
    required this.vendor,
    required this.id,
    required this.status,
    required this.index,
    required this.onUpdate,
    required this.onBlockToggle,
    this.setLoading, 
    this.onReloadParent,
  });

  @override
  State<VendorActionButtons> createState() => _VendorActionButtonsState();
}

class _VendorActionButtonsState extends State<VendorActionButtons> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      color: Colors.white,
      offset: const Offset(0, 40),
      onSelected: (value) async {
        if (value == 'edit') {
          final updatedVendor = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewVendorPage(
                mode: "edit",
                vendor: widget.row,
                dbId: widget.row["id"]?.toString(),
                onCompleted: (dbId) {
                  widget.onUpdate(widget.index, widget.row);
                   widget.onReloadParent?.call();
                },
              ),
            ),
          );
          if (updatedVendor != null && updatedVendor is Map<String, dynamic>) {
            widget.onUpdate(widget.index, updatedVendor);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vendor data updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
        else if (value == 'block') {
          final isDisabled = widget.row['status'] == 'Disable';
          final actionStatus = isDisabled ? 'Enable' : 'Disable';

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isDisabled ? 'Unblock Vendor' : 'Block Vendor'),
              content: Text(
                isDisabled
                    ? 'Are you sure you want to unblock this vendor?'
                    : 'Are you sure you want to block this vendor?',
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: Text(isDisabled ? 'Unblock' : 'Block',
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );

          if (confirm != true) return;

          // Show screen-wide loader
          widget.setLoading?.call(true);

          try {
            final result = await UpdateVendorStatus.updateVendorStatusById(
              id: widget.id.toString(),
              status: actionStatus,
            );

            if (result["status"] == true) {
              final updatedVendor = Map<String, dynamic>.from(widget.row);
              updatedVendor['status'] = actionStatus;
              widget.onBlockToggle(widget.index, updatedVendor);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isDisabled
                    ? 'Vendor Unblocked Successfully!': 'Vendor Blocked Successfully!'),
                  backgroundColor:Colors.green
                
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result["message"] ?? 'Failed to update status'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error updating vendor status: $e"),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            widget.setLoading?.call(false); // hide screen loader
          }
        } else if (value == 'view') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VendorDetailPage(row: widget.row),
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
                widget.row['status'] == 'Disable'
                    ? Icons.lock_open
                    : Icons.block,
                color: widget.row['status'] == 'Disable'
                    ? Colors.green
                    : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                widget.row['status'] == 'Disable' ? 'Unblock' : 'Block',
                style: const TextStyle(fontSize: 15),
              ),
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
      ],
    );
  }

  Future<void> updatedVendorStatus(BuildContext context) async {
    final id = widget.vendor['id']?.toString() ?? '';
    if (id.isEmpty) {
      _showSnackBar(context, 'Cannot update status: ID is missing', Colors.red);
      return;
    }

    final currentStatus = widget.row['status']?.toString() ?? 'Enable';
    final newStatus = currentStatus == 'Enable' ? 'Disable' : 'Enable';

    try {
      final result = await UpdateVendorStatus.updateVendorStatusById(

        id: id,
        status: newStatus,
      );

      if (result["status"] == true) {
        final updatedVendor = Map<String, dynamic>.from(widget.row);
        updatedVendor["status"] = newStatus;
        widget.onBlockToggle(widget.index, updatedVendor);

        _showSnackBar(
          context,
          newStatus == 'Enable'
              ? 'Vendor Enabled Successfully!'
              : 'Vendor Disabled Successfully!',
          newStatus == 'Enable' ? Colors.green : Colors.red,
        );
      } else {
        _showSnackBar(
          context,
          result["message"] ?? 'Failed to update vendor status',
          Colors.redAccent,
        );
      }
    } catch (e) {
      _showSnackBar(
        context,
        "Error updating vendor status: $e",
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
