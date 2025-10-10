import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/services/adminServiceApi/getallvendor.dart';
import '/models/Vendor_model.dart';

import 'widgets/AddNewVendorpage.dart';
import 'widgets/vendorSummaryCard.dart';
import 'widgets/vendor_Searchbar.dart';

class VendorTablePage extends StatefulWidget {
  final String token;
  const VendorTablePage({
    super.key,
    required this.token
    
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

  /// ✅ Fetch vendors from API
  /// 
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
      final vendorJsonList =
          vendors.map((v) => jsonEncode(v.toJson())).toList();
      await prefs.setStringList('vendors', vendorJsonList);
    } catch (e) {
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
            vendor.email.toLowerCase().contains(query) ||
            vendor.mobileNo.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addNewVendor(Vendor newVendor) {
    setState(() {
      vendorData.add(newVendor);
      _filterData();
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

  void _deleteVendor(int index) {
    setState(() {
      vendorData.removeAt(index);
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
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: _loadVendorsFromApi,
                              child: filteredData.isEmpty
                                  ? ListView(
                                      children: [
                                        SizedBox(height: 200),
                                        Center(
                                            child: Text(
                                                'No vendor data available.')),
                                      ],
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isWideScreen ? 2 : 1,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio:
                                            isWideScreen ? 2.2 : 1.9,
                                      ),
                                      itemCount: filteredData.length,
                                      itemBuilder: (context, index) {
                                        final vendor = filteredData[index];
                                        return VendorSummaryCard(
                                          row: vendor.toJson(),
                                          index: index,
                                          onUpdate: (i, updated) =>
                                              _updateVendor(
                                                  i, Vendor.fromJson(updated)),
                                          onBlockToggle: (i, updated) =>
                                              _toggleVendorBlockStatus(
                                                  i, Vendor.fromJson(updated)),
                                          onDelete: _deleteVendor,
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
                            builder: (context) => NewVendorPage()),
                      );
                      if (newVendor != null && newVendor is Vendor) {
                        _addNewVendor(newVendor);
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
            ],
          );
        },
      ),
    );
  }
}
