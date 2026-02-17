import 'package:flutter/material.dart';
import 'package:myapp/modules/vendor/widgets/voucher/widgets/voucher_customerSearch.dart';
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
  List<VoucherModel> voucherData = [];
  List<VoucherModel> filteredData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVouchers();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Convert VoucherModel → Map (for Search widget only)
  List<Map<String, dynamic>> get voucherDataMap =>
      voucherData.map((v) => v.toJson()).toList();

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
                // 🔍 SEARCH WIDGET (SEPARATE FILE)
                VoucherCustomerSearch(
                  voucherData: voucherDataMap,

                  /// When search finishes filtering
                  onSearchResult: (list) {
                    setState(() {
                      filteredData = list
                          .map((map) => VoucherModel.fromJson(map))
                          .toList();
                    });
                  },

                  /// If you want to track text changes
                  onChanged: (txt) {},

                  /// For onChange inside TextField
                  onSearchChanged: (value) {},

                  /// Mic button pressed callback
                  onMicPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mic Pressed")),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // LIST / GRID VIEW
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchVouchers,
                    child: filteredData.isEmpty
                        ? const Center(child: Text("No Voucher Data Found"))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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

          // Loader
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

// ------------- CARD WIDGET -------------------

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

            _infoRow('Amount', row['amount'] ?? '', Colors.teal),
            _infoRow('Customer Email', row['customerEmail'] ?? '', Colors.green),
            _infoRow('Status', row['status'] ?? 'Null', Colors.orange),
          ],
        ),
      ),
    );
  }

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

// ---------------- PDF VIEW BUTTON --------------------

class VoucherActionButtons extends StatelessWidget {
  final Map<String, dynamic> row;
  final int index;

  const VoucherActionButtons({
    super.key,
    required this.row,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'view') {
          openPdf(context, row['pdfURL'] ?? '');
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
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
