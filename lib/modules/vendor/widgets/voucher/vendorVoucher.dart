import 'package:flutter/material.dart';
import '/models/vendor_module/vendor_voucherModel.dart';
import '/services/vendor_module_service_Api/VendorCustomer_Voucher/getAllVoucherByVendor.dart';
import 'package:url_launcher/url_launcher.dart'; 

class VendorVoucherpage extends StatefulWidget {
  final String Id;

  const VendorVoucherpage({super.key, required this.Id});

  @override
  State<VendorVoucherpage> createState() => _VendorVoucherpageState();
}

class _VendorVoucherpageState extends State<VendorVoucherpage> {
  final TextEditingController searchController = TextEditingController();
  List<VoucherModel> voucherData = [];
  List<VoucherModel> filteredData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVouchers();
    searchController.addListener(_filterVouchers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchVouchers() async {
    setState(() => isLoading = true);
    try {
      final vouchers = await GetAllVoucher.getAllVoucherByVendor();
      setState(() {
        voucherData = vouchers;
        filteredData = List.from(vouchers);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterVouchers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = voucherData.where((v) {
        return v.amount!.toLowerCase().contains(query) ||
            v.customerName!.toLowerCase().contains(query) ||
            v.customerEmail!.toLowerCase().contains(query) ||
            v.status!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      filteredData = List.from(voucherData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔍 Integrated Search Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          hintText: 'Search customers...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 🧾 List/Grid of Vouchers
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchVouchers,
                    child: filteredData.isEmpty
                        ? const Center(child: Text('No Voucher Data Found'))
                        : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 2 : 1,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: isWide ? 2.8 : 2,
                            ),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final model = filteredData[index];
                              return VoucherCustomerSummaryCard(
                                row: model.toJson(),
                                index: index,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ⏳ Loader
          if (isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

// 🧩 Voucher Summary Card Widget


class VoucherCustomerSummaryCard extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;

  const VoucherCustomerSummaryCard({
    super.key,
    required this.row,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Name + Menu
            Row(
              children: [
                Expanded(
                  child: Text(
                    row['customerName'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                VoucherActionButtons(row: row, index: index),
              ],
            ),
            const SizedBox(height: 8),

            // Info Rows with colors
            _infoRow('Amount', row['amount'] ?? '', Colors.teal),
            _infoRow('Customer Email', row['customerEmail'] ?? '', Colors.green),
            //_infoRow('Customer Pincode', row['customerPincode'] ?? '', Colors.orange),
            _infoRow('Status', row['status'] ?? 'Null', Colors.orange),

          ],
        ),
      ),
    );
  }

  /// Colored information row
  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}



// view section

class VoucherActionButtons extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;

  const VoucherActionButtons({
    super.key,
    required this.row,
    required this.index,
  });

  Future<void> _openPdf(BuildContext context) async {
    final pdfUrl = row['pdfURL'];

    // CASE 1: No PDF
    if (pdfUrl == null || pdfUrl.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No PDF available for this voucher."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // CASE 2: Try to open PDF
    final Uri uri = Uri.parse(pdfUrl.toString());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // Show success message only *after* launch attempt
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("PDF opened successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not open PDF: $pdfUrl"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'view') {
          _openPdf(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, color: Colors.blue, size: 18),
              SizedBox(width: 5),
              Text('View PDF'),
            ],
          ),
        ),
      ],
    );
  }
}
