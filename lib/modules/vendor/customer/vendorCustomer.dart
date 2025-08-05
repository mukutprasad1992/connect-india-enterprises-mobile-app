import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'vendorCustomerDrawer.dart';
import 'addNewCustomer.dart';
import 'vendorcustomerIconbuttons.dart';

class VendorTablePage extends StatefulWidget {
  const VendorTablePage({super.key});

  @override
  State<VendorTablePage> createState() => _VendorTablePageState();
}

class _VendorTablePageState extends State<VendorTablePage> {
  Map<String, bool> columnVisibility = {
    'ID': true,
    'Business name': true,
    'Business representative': true,
    'Email': true,
    'Phone': true,
    'Vendor code': true,
    'Create at': true,
    'Status': true,
  };

  String searchText = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> vendorData = [];

  @override
  void initState() {
    super.initState();
    _loadVendors();
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
    });
  }

  void _addNewVendor(Map<String, String> newVendor) {
    setState(() {
      vendorData.add(newVendor);
    });
    _saveVendors();
  }

  void _updateVendor(int index, Map<String, String> updatedVendor) {
    setState(() {
      vendorData[index] = updatedVendor;
    });
    _saveVendors();
  }

  bool _isVisible(String key) => columnVisibility[key] ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: VendorDrawer(
        columnVisibility: columnVisibility,
        searchController: _searchController,
        searchText: searchText,
        onSearchChanged: (value) => setState(() => searchText = value),
        onCheckboxChanged: (column, value) =>
            setState(() => columnVisibility[column] = value ?? false),
        onToggleAll: () {
          setState(() {
            bool newValue = !columnVisibility.values.every((v) => v);
            for (var key in columnVisibility.keys) {
              columnVisibility[key] = newValue;
            }
          });
        },
        onReset: () {
          setState(() {
            for (var key in columnVisibility.keys) {
              columnVisibility[key] = false;
            }
            _searchController.clear();
            searchText = '';
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Builder(
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  const Text(
                    'Vendor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
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
                          backgroundColor: Colors.indigo),
                      child: const Text("Add",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: vendorData.isEmpty
                  ? const Center(child: Text('No vendor data available.'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return ListView.builder(
                          itemCount: vendorData.length,
                          itemBuilder: (context, index) {
                            final row = vendorData[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 5,
                              shadowColor: Colors.indigo.withOpacity(0.3),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      constraints.maxWidth > 600 ? 32 : 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            row['Business name'] ?? 'No Name',
                                            style: TextStyle(
                                              fontSize:
                                                  constraints.maxWidth > 600
                                                      ? 20
                                                      : 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[900],
                                            ),
                                          ),
                                        ),
                                        VendorActionButtons(
                                          row: row,
                                          index: index,
                                          onUpdate: _updateVendor,
                                          onBlockToggle: (i, updatedVendor) {
                                            setState(() {
                                              vendorData[i] = updatedVendor;
                                            });
                                            _saveVendors();
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    if (_isVisible('ID'))
                                      _buildRowItem(Icons.confirmation_number,
                                          'ID', row['ID'] ?? ''),
                                    if (_isVisible('Business name'))
                                      _buildRowItem(Icons.business,
                                          'Business Name', row['Business name'] ?? ''),
                                    if (_isVisible('Business representative'))
                                      _buildRowItem(
                                          Icons.people,
                                          'Business Representative',
                                          row['Business representative'] ?? ''),
                                    if (_isVisible('Email'))
                                      _buildRowItem(Icons.email, 'Email',
                                          row['email'] ?? ''),
                                    if (_isVisible('Phone'))
                                      _buildRowItem(Icons.phone, 'Phone',
                                          row['phone'] ?? ''),
                                    if (_isVisible('Vendor code'))
                                      _buildRowItem(Icons.qr_code,
                                          'Vendor Code', row['Vendor code'] ?? ''),
                                    if (_isVisible('Create at'))
                                      _buildRowItem(Icons.calendar_today,
                                          'Created At', row['Create at'] ?? ''),
                                    if (_isVisible('Status'))
                                      _buildRowItem(
                                        row['Status'] == 'Active'
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        'Status',
                                        row['Status']!,
                                        iconColor: row['Status'] == 'Active'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(IconData icon, String label, String value,
      {Color iconColor = Colors.black54}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
