import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/admin_module_service_Api/customer/getAllCustomer.dart';
import '/models/customerModel.dart';
import 'widgets/Customer_Searchbar.dart';
import 'widgets/customerSummaryCard.dart';

class CustomerTablePage extends StatefulWidget {
  final String token;
  const CustomerTablePage({super.key, required this.token});

  @override
  State<CustomerTablePage> createState() => _CustomerTablePageState();
}

class _CustomerTablePageState extends State<CustomerTablePage> {
  List<CustomerModel> customerData = [];
  List<CustomerModel> filteredData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          widget.token.isNotEmpty ? widget.token : prefs.getString("KEYTOKEN");

      if (token == null || token.isEmpty) {
        _redirectToLogin();
        return;
      }

      final response = await GetAllCustomer.getAllCustomer(token: token);
      final data = response["data"];

      List<CustomerModel> loadedData = [];

      if (data is List) {
        loadedData = data.map((json) => CustomerModel.fromJson(json)).toList();
      } else if (data is Map) {
        loadedData = [CustomerModel.fromJson(Map<String, dynamic>.from(data))];
      }

      setState(() {
        customerData = loadedData;
        filteredData = List.from(customerData);
      });

      await _saveCustomerCache();
    } catch (e) {
      debugPrint("API fetch failed: $e");
      await _loadCustomerCache();
      setState(() {
        errorMessage = "⚠️ Failed to load live data, showing cached results.";
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveCustomerCache() async {
    final prefs = await SharedPreferences.getInstance();
    final customerJsonList =
        customerData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('cached_customers', customerJsonList);
  }

  Future<void> _loadCustomerCache() async {
    final prefs = await SharedPreferences.getInstance();
    final customerJsonList = prefs.getStringList('cached_customers') ?? [];

    final loadedData = customerJsonList
        .map((jsonStr) => CustomerModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      customerData = loadedData;
      filteredData = List.from(customerData);
    });
  }

  void _filterCustomer(String query) {
    setState(() {
      
      filteredData = customerData.where((item) {
        return item.id.toString().contains(query) ||
            (item.phone ?? '').toLowerCase().contains(query) ||
            (item.businessRepresentative ?? '').toLowerCase().contains(query) ||
            (item.businessName ?? '').toLowerCase().contains(query) ||
            (item.email ?? '').toLowerCase().contains(query);
      }).toList();
    });
  }

  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Bar
            CustomerSearchBar(
              customerData: customerData,
              onSearchResult: (filteredList) {
                setState(() {
                  filteredData = filteredList;
                });
              },
              onChanged: (text) {},
              onMicPressed: () {},
              onSearchChanged: (searchText) {},
            ),

            const SizedBox(height: 10),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),

            // 📋 Customer Grid
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredData.isEmpty
                      ? const Center(child: Text('No customer data found.'))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isWide ? 2 : 1,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: isWide ? 2.2 : 1.9,
                              ),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final customer = filteredData[index];
                                return CustomerSummaryCard(
                                  row: customer,
                                  index: index,
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
}
