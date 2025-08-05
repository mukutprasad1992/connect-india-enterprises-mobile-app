import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/generatepage.dart';
import 'widgets/voucherSummaryCard.dart';
import 'widgets/voucherSearchBar.dart';

class VoucherTablePage extends StatefulWidget {
  const VoucherTablePage({
    super.key,
    //voucherData: voucherData,
  });

  @override
  State<VoucherTablePage> createState() => _VoucherTablePageState();
}

class _VoucherTablePageState extends State<VoucherTablePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> voucherData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadVouchers();
    _searchController.addListener(_applySearchFilter);
  }

  Future<void> _saveVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final voucherJsonList = voucherData.map(jsonEncode).toList();
    await prefs.setStringList('vouchers', voucherJsonList);
  }

  Future<void> _loadVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final voucherJsonList = prefs.getStringList('vouchers') ?? [];
    final loadedData = voucherJsonList
        .map((jsonStr) => Map<String, dynamic>.from(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      voucherData = loadedData;
      filteredData = List.from(voucherData);
    });
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = voucherData.where((voucher) {
        final name = voucher['CustomerName']?.toLowerCase() ?? '';
        final code = voucher['VoucherCode']?.toLowerCase() ?? '';
        return name.contains(query) || code.contains(query);
      }).toList();
    });
  }

  void _updateVoucher(int index, Map<String, dynamic> updatedVoucher) {
    setState(() {
      voucherData[index] = updatedVoucher;
    });
    _saveVouchers();
    _applySearchFilter();
  }

  void _toggleBlockStatus(int index) {
    setState(() {
      final currentStatus = voucherData[index]['Status'] ?? 'Active';
      voucherData[index]['Status'] =
          currentStatus == 'Blocked' ? 'Active' : 'Blocked';
    });
    _saveVouchers();
    _applySearchFilter();
  }

  void _addNewVoucher(Map<String, dynamic> newVoucher) {
    setState(() {
      voucherData.add(newVoucher);
    });
    _saveVouchers();
    _applySearchFilter();
  }

  void _deleteVoucher(int index) {
    setState(() {
      voucherData.removeAt(index);
    });
    _saveVouchers();
    _applySearchFilter();
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
                    // 🔍 Voucher Search Bar
                    VoucherSearchBar(
                      onChanged: (value) {},
                      voucherData: voucherData,
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList;
                        });
                      },
                      onMicPressed: () {},
                      onSearchChanged: (searchText) {},
                    ),

                    const SizedBox(height: 10),

                    // 🧾 Voucher Grid/List
                    Expanded(
                      child: filteredData.isEmpty
                          ? const Center(
                              child: Text('No voucher data available.'))
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
                                return VoucherSummaryCard(
                                  row: row,
                                  index: index,
                                  onUpdate: (updatedRow) =>
                                      _updateVoucher(index, updatedRow),
                                  onBlockToggle: () =>
                                      _toggleBlockStatus(index),
                                  onDelete: () => _deleteVoucher(index),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // ➕ Floating Add Button
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newVoucher = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GenerateVoucherPage()),
                      );
                      if (newVoucher != null &&
                          newVoucher is Map<String, dynamic>) {
                        _addNewVoucher(newVoucher);
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
