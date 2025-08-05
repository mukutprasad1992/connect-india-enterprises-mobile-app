import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/NewVendorpage.dart';
import 'widgets/vendorSummaryCard.dart';
import 'widgets/vendor_Searchbar.dart';

class VendorTablePage extends StatefulWidget {
  const VendorTablePage({super.key});

  @override
  State<VendorTablePage> createState() => _VendorTablePageState();
}

class _VendorTablePageState extends State<VendorTablePage> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> vendorData = [];
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadVendors();
    searchController.addListener(_filterData);
  }

  Future<void> _saveVendors() async {
    final prefs = await SharedPreferences.getInstance();
    final vendorJsonList =
        vendorData.map((vendor) => jsonEncode(vendor)).toList();
    await prefs.setStringList('vendors', vendorJsonList);
  }

  Future<void> _loadVendors() async {
    final prefs = await SharedPreferences.getInstance();
    final vendorJsonList = prefs.getStringList('vendors') ?? [];
    setState(() {
      vendorData = vendorJsonList
          .map((vendorJson) => Map<String, String>.from(jsonDecode(vendorJson)))
          .toList();
      filteredData = List.from(vendorData); // Initially same
    });
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredData = vendorData.where((vendor) {
        return vendor.values.any(
          (value) => value.toLowerCase().contains(query),
        );
      }).toList();
    });
  }

  void _addNewVendor(Map<String, String> newVendor) {
    setState(() {
      vendorData.add(newVendor);
      _filterData();
    });
    _saveVendors();
  }

  void _updateVendor(int index, Map<String, String> updatedVendor) {
    setState(() {
      vendorData[index] = updatedVendor;
      _filterData();
    });
    _saveVendors();
  }

  void _toggleVendorBlockStatus(int index, Map<String, String> updatedVendor) {
    setState(() {
      vendorData[index] = updatedVendor;
      _filterData();
    });
    _saveVendors();
  }

  void _deleteVendor(int index) {
    setState(() {
      vendorData.removeAt(index);
      _filterData();
    });
    _saveVendors();
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
                      vendorData: vendorData,
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList;
                        });
                      },
                      onMicPressed: () {},
                      onSearchChanged: (searchText) {},
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: filteredData.isEmpty
                          ? const Center(
                              child: Text('No vendor data available.'))
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isWideScreen ? 2 : 1,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: isWideScreen ? 2.2 : 1.9,
                              ),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final row = filteredData[index];
                                return VendorSummaryCard(
                                  row: row,
                                  index: index,
                                  onUpdate: _updateVendor,
                                  onBlockToggle: _toggleVendorBlockStatus,
                                  onDelete: _deleteVendor,
                                );
                              },
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
                      if (newVendor != null &&
                          newVendor is Map<String, String>) {
                        _addNewVendor(newVendor);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
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
