import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/models/createVouchermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/Vouchermodel.dart';
import '/services/admin_module_service_Api/voucher/getAllvoucher.dart';
import 'widgets/voucherSearchBar.dart';
import 'widgets/voucherSummaryCard.dart';
import 'widgets/generate_edit_page.dart';

class VoucherTablePage extends StatefulWidget {
  final Map<String, dynamic>? voucherModel;

  const VoucherTablePage({super.key, this.voucherModel});

  @override
  State<VoucherTablePage> createState() => _VoucherTablePageState();
}

class _VoucherTablePageState extends State<VoucherTablePage> {
  final TextEditingController searchController = TextEditingController();
  List<VoucherModel> voucherData = [];
  List<VoucherModel> filteredData = [];
  List<CreateVoucherModel> voucherDetials = [];
  List<CreateVoucherModel> filteredVoucherDetials = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVouchersFromApi();
    searchController.addListener(_applySearchFilter);
  }

  Future<void> _saveVouchers() async {
    final prefs = await SharedPreferences.getInstance();
    final voucherJsonList = voucherData.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList('vouchers', voucherJsonList);
  }

  Future<void> _loadVouchersFromApi() async {
    setState(() => isLoading = true);
    try {
      final vouchers = await GetAllVoucher.getAllCustomervoucher();
      setState(() {
        voucherData = vouchers;
        filteredData = List.from(vouchers);
      });
      await _saveVouchers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading vouchers: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applySearchFilter() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = voucherData.where((v) {
        return (v.customerName).toLowerCase().contains(query) ||
            (v.vendorBusinessName ?? '').toLowerCase().contains(query) ||
            (v.status ?? '').toLowerCase().contains(query) ||
            (v.voucherCode).toLowerCase().contains(query) ||
            (v.amount).toLowerCase().contains(query);
      }).toList();
    });
  }

  void updateVoucher(int index, CreateVoucherModel updatedVoucher) {
    setState(() {
      voucherDetials[index] = updatedVoucher;
      filteredVoucherDetials[index] = updatedVoucher;
    });
    _saveVouchers();
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
          final isWide = constraints.maxWidth > 600;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    VoucherSearchBar(
                      onChanged: (_) {},
                      voucherData: voucherData.map((v) => v.toJson()).toList(),
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList
                              .map((e) => VoucherModel.fromJson(e))
                              .toList();
                        });
                      },
                      onMicPressed: () {},
                      onSearchChanged: (value) => _applySearchFilter(),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadVouchersFromApi,
                        child: filteredData.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 200),
                                  Center(
                                    child: Text('No vouchers found'),
                                  ),
                                ],
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWide ? 2 : 1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: isWide ? 2.6 : 2.0,
                                ),
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  final voucher = filteredData[index];
                                  return VoucherSummaryCard(
                                    row: voucher.toJson(),
                                    index: index,
                                    onDelete: (i) {
                                      setState(() {
                                        filteredData.removeAt(i);
                                        voucherData.removeAt(i);
                                      });
                                      _saveVouchers();
                                    },
                                    onUpdate: (i, updated) {
                                      setState(() {
                                        final updatedVoucher =
                                            VoucherModel.fromJson(updated);
                                        voucherData[i] = updatedVoucher;
                                        filteredData[i] = updatedVoucher;
                                      });
                                      _saveVouchers();

                                      Navigator.pop(context);
                                    },
                                    onStatusToggle: (i, updated) {
                                      setState(() {
                                        final updatedVoucher =
                                            VoucherModel.fromJson(updated);
                                        voucherData[i] = updatedVoucher;
                                        filteredData[i] = updatedVoucher;
                                      });
                                    },
                                    onReloadParent: _loadVouchersFromApi,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.small(
          backgroundColor: Colors.deepPurple,
          elevation: 6,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GenerateEditVoucherPage(
                  mode: 'add',
                  CreateVoucherModel: {},
                  onCompleted: (dbId) => _loadVouchersFromApi(),
                ),
              ),
            );

            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Voucher added successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Icon(Icons.add, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
