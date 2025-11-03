import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/services/admin_module_service_Api/vendor/getallvendor.dart';
import '/models/Vendor_model.dart';
import 'widgets/add_edit_vendor.dart';
import 'widgets/vendorSummaryCard.dart';
import 'widgets/vendor_Searchbar.dart';

class VendorTablePage extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? vendor;
  final String? dbId;
  const VendorTablePage({
    super.key,
    required this.token,
    this.vendor,
    this.dbId,
  });

  @override
  State<VendorTablePage> createState() => _VendorTablePageState();
}

class _VendorTablePageState extends State<VendorTablePage> {
  final TextEditingController searchController = TextEditingController();
  List<Vendor> vendorData = [];
  List<Vendor> filteredData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVendorsFromApi();
    searchController.addListener(_filterData);
  }

  ///  Fetch vendors from API

  Future<void> _loadVendorsFromApi() async {
    setState(() => isLoading = true);
    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : (await SharedPreferences.getInstance()).getString("KEYTOKEN");

      if (token == null) {
        _redirectToLogin();
        return;
      }
      final vendors = await VendorApi.fetchVendorsData();
      for (var v in vendors) {}
      setState(() {
        vendorData = vendors;
        filteredData = List.from(vendors);
        isLoading = false;
      });

      // (Optional) save to SharedPreferences for offline usage

      final prefs = await SharedPreferences.getInstance();
      final vendorJsonList = vendors.map((v) => jsonEncode(v.toJson())).toList();
      await prefs.setStringList('vendors', vendorJsonList);
    }catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredData = vendorData.where((vendor) {
        return vendor.businessName.toLowerCase().contains(query) ||
          vendor.businessRepresentative.toLowerCase().contains(query) ||
          vendor.vendorCode.toLowerCase().contains(query)||
          vendor.email.toLowerCase().contains(query) ||
          vendor.mobileNo.toLowerCase().contains(query)||
          vendor.status.toLowerCase().contains(query);

      }).toList();
    });
  }
  void _updateVendor(int index, Vendor updatedVendor) {
    setState(() {
      vendorData[index] = updatedVendor;
      _filterData();
    });
  }

  void _toggleVendorBlockStatus(int index, Vendor updatedVendor) {
    setState(() {
      vendorData[index] = updatedVendor;
      _filterData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    VendorSearchBar(
                      onChanged: (value) {},
                      vendorData: vendorData.map((v) => v.toJson()).toList(),
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList
                              .map<Vendor>((row) => Vendor.fromJson(row))
                              .toList();
                        });
                      },
                      onMicPressed: () {},
                      onSearchChanged: (searchText) {},
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadVendorsFromApi,
                        child: filteredData.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 200),
                                  Center(
                                      child: Text('No vendor data available.')),
                                ],
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWideScreen ? 2 : 1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: isWideScreen ? 2.8 : 2,
                                ),
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  final vendor = filteredData[index];
                                  return VendorSummaryCard(
                                    row: vendor.toJson(),
                                    index: index,
                                    token: widget.token,
                                    onUpdate: (i, updated) => _updateVendor(
                                        i, Vendor.fromJson(updated)),
                                    onBlockToggle: (i, updated) =>
                                        _toggleVendorBlockStatus(
                                            i, Vendor.fromJson(updated)),
                                    setLoading: (val) {
                                      setState(() {
                                        isLoading = val;
                                      });
                                    },
                                    onReloadParent: _loadVendorsFromApi,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Add Button
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newVendor = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewVendorPage(
                            token: widget.token,
                            mode: "add",
                            vendor: {},
                            onCompleted: (dbId) {
                              _loadVendorsFromApi();
                            },
                          ),
                        ),
                      );
                      if (newVendor != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Vendor Added Successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),

              // SCREEN-WIDE LOADER
              if (isLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
