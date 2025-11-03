import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/vendor_module/vendor_customer_model.dart';
import '/services/vendor_module_service_Api/Vendor_customer/getAll_customerByvendor_Id.dart';
import 'widgets/add_edit_Customer.dart';
import 'widgets/Vendor_customer_SummaryCard.dart';
import 'widgets/Vendor_customerSearch.dart';

class VendorCustomerPage extends StatefulWidget {
  final String vendorId;

  const VendorCustomerPage({
    super.key,
    required this.vendorId,
  });

  @override
  State<VendorCustomerPage> createState() => _VendorCustomerPageState();
}

class _VendorCustomerPageState extends State<VendorCustomerPage> {
  final TextEditingController searchController = TextEditingController();
  List<VendorCustomerModel> customerData = [];
  List<VendorCustomerModel> filteredData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  static Future<int?> getLoginkey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("KEYLOGINID");
  }
  Future<void> fetchCustomers() async {
    setState(() => isLoading = true);
    try {
      final loginId = await getLoginkey();
      final customers = await GetAllVendorCustomer.getAllCustomerByVendorId(
        // vendorId: widget.vendorId,
        vendorId: loginId.toString(),
      );
      setState(() {
        customerData = customers;
        filteredData = List.from(customers);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = customerData.where((c) {
        return c.name!.toLowerCase().contains(query) ||
            c.email!.toLowerCase().contains(query) ||
            c.phone!.toLowerCase().contains(query) ||
            c.pincode!.toLowerCase().contains(query);
      }).toList();
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
                VendorCustomerSearch(
                  onChanged: (value) {},
                  vendorData: customerData.map((v) => v.toJson()).toList(),
                  onSearchResult: (filteredList) {
                    setState(() {
                      filteredData = filteredList
                          .map<VendorCustomerModel>((row) => VendorCustomerModel.fromJson(row))
                          .toList();
                    });
                  },
                  onMicPressed: () {},
                  onSearchChanged: (searchText) {},
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchCustomers,
                    child: filteredData.isEmpty
                        ? const Center(child: Text('No Customer Data'))
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
                              return VendorCustomerSummaryCard(
                                row: model.toJson(),
                                index: index,
                                onUpdate: (i, updated) => setState(() =>
                                    filteredData[i] =
                                        VendorCustomerModel.fromJson(updated)),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Loading overlay
          if (isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // ✅ Replaced FloatingActionButton with this:
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final newCustomer = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewVendorCustomerPage(
                        
                        mode: "add",
                        vendorCustomerModel: const {},
                        onCompleted: (_) => fetchCustomers(),
                      ),
                    ),
                  );

                  if (newCustomer != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Customer Added Successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(10),
                  shape: const CircleBorder(),
                  elevation: 4,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
