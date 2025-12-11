import 'package:flutter/material.dart';
import 'package:myapp/modules/admin/widgets/voucher/widgets/generate_edit_page.dart';
import '/services/admin_module_service_Api/voucher/updateVoucherStatusByid.dart';
import '/services/admin_module_service_Api/voucher/deleteVoucher.dart';
import 'package:url_launcher/url_launcher.dart';

class VoucherActionButtons extends StatefulWidget {
  final Map<String, dynamic> CreateVoucherModel;
  final Map<String, dynamic> row;
  final int index;
  final int id;
  final String status;
  final Function(int index, Map<String, dynamic> updatedVoucher) onUpdate;
  final Function(int index, Map<String, dynamic> updatedVoucher) onStatusToggle;
  final Function(int index) onDelete;
  final Function(bool isLoading)? setLoading;
  final VoidCallback? onReloadParent;

  /// NEW: callback to show/hide loader in parent

  const VoucherActionButtons({
    super.key,
    required this.CreateVoucherModel,
    required this.row,
    required this.id,
    required this.index,
    required this.status,
    required this.onUpdate,
    required this.onStatusToggle,
    required this.onDelete,
    this.setLoading,
    this.onReloadParent,
  });

  @override
  State<VoucherActionButtons> createState() => _VoucherActionButtonsState();
}

class _VoucherActionButtonsState extends State<VoucherActionButtons> {
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
          //  Edit voucher
          final updatedVoucher = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenerateEditVoucherPage(
                mode: "edit",
                CreateVoucherModel: widget.row,
                dbId: widget.row["id"]?.toString(),
                onCompleted: (dbId) {
                  widget.onReloadParent?.call();
                },
              ),
            ),
          );

          if (updatedVoucher != null &&
              updatedVoucher is Map<String, dynamic>) {
            widget.onUpdate(widget.index, updatedVoucher);
            _showSnackBar(
                context, "Voucher updated successfully!", Colors.green);
          }
        } else if (value == 'status') {
          final currentStatus = widget.row['status']?.toString() ?? 'Enable';
          final isRedeemed = currentStatus == 'Disable';

          if (isRedeemed) {
            //  Already redeemed — show info message
            _showSnackBar(
              context,
              'User has already redeemed this voucher.',
              Colors.orange,
            );
            return;
          }
          //  Redeem confirmation dialog
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Redeem Voucher',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Are you sure you want to redeem this voucher?',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: const Text(
                    'Redeem',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );

          if (confirm != true) return;

          widget.setLoading?.call(true);

          try {
            // 🔄 Update status to "Disable" (redeemed)
            final result = await UpdateVoucherStatus.updateVoucherStatusById(
              id: widget.id.toString(),
              status: 'Disable',
            );

            if (result["status"] == true) {
              // 🟢 Update local UI state
              final updatedVoucher = Map<String, dynamic>.from(widget.row);
              updatedVoucher['status'] = 'Disable';
              widget.onStatusToggle(widget.index, updatedVoucher);

              _showSnackBar(
                context,
                'Voucher redeemed successfully!',
                Colors.green,
              );
            } else {
              _showSnackBar(
                context,
                result["message"] ?? "Failed to redeem voucher",
                Colors.redAccent,
              );
            }
          } catch (e) {
            _showSnackBar(context, "Error: $e", Colors.red);
          } finally {
            widget.setLoading?.call(false);
          }
        } else if (value == 'delete') {
          //  Delete voucher
          final confirmDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Delete Voucher",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              content: const Text(
                  "Are you sure you want to delete this voucher?",
                  style: TextStyle(fontSize: 14)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );

          if (confirmDelete != true) return;

          widget.setLoading?.call(true);

          try {
            final result =
                await deleteVoucher.DeleteVoucherById(id: widget.id.toString());

            if (result["status"] == true) {
              widget.onDelete(widget.index);
              _showSnackBar(
                  context, "Voucher deleted successfully!", Colors.green);
            } else {
              _showSnackBar(
                  context,
                  result["message"] ?? "Failed to delete voucher",
                  Colors.redAccent);
            }
          } catch (e) {
            _showSnackBar(context, "Error deleting voucher: $e", Colors.red);
          } finally {
            widget.setLoading?.call(false);
          }
        } 
        else if (value == 'view') {
          openPdf(context, widget.row['pdfURL'] ?? '');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.amber, size: 20),
              SizedBox(width: 5),
              Text('Edit', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'status',
          child: Row(
            children: [
              Icon(
                widget.row['status'] == 'Disable'
                    ? Icons.lock_open
                    : Icons.redeem, 
                color: widget.row['status'] == 'Disable'
                    ? Colors.grey
                    : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                widget.row['status'] == 'Disable' ? 'Redeemed' : 'Redeem',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 5),
              Text('Delete', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, color: Colors.blue, size: 20),
              SizedBox(width: 5),
              Text('View Pdf', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
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

  Future<void> openPdf(BuildContext context, String pdfUrl) async {
    if (pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No PDF available for this voucher."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final Uri uri = Uri.parse(pdfUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        // 🔁 Try launching in browser if app launch fails
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Could not open PDF in browser or app."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening PDF: $e")),
      );
    }
  }
}
