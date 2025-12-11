import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/admin_module_service_Api/customer/getAllCustomer.dart';
import '/models/customerModel.dart';
import 'widgets/Customer_Searchbar.dart';
import 'widgets/customerSummaryCard.dart';

class CustomerTablePage extends StatefulWidget {
  const CustomerTablePage({super.key});

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

  /// 🔹 Fetch all customers from API (with fallback to cache)
  Future<void> _fetchCustomerData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await GetAllCustomer.getAllCustomer();
      final data = response["data"];

      List<CustomerModel> loadedData = [];

      if (data is List) {
        loadedData = data.map((json) => CustomerModel.fromJson(json)).toList();
      } else if (data is Map) {
        loadedData = [CustomerModel.fromJson(Map<String, dynamic>.from(data))];
      }

      if (mounted) {
        setState(() {
          customerData = loadedData;
          filteredData = List.from(customerData);
        });
      }

      await _saveCustomerCache();
    } catch (e) {
      await _loadCustomerCache();
      setState(() {
        errorMessage = "Failed to load live data, showing cached results.";
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// 💾 Cache customer data locally
  Future<void> _saveCustomerCache() async {
    final prefs = await SharedPreferences.getInstance();
    final customerJsonList =
        customerData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('cached_customers', customerJsonList);
  }

  /// 📦 Load cached customers if live API fails
  Future<void> _loadCustomerCache() async {
    final prefs = await SharedPreferences.getInstance();
    final customerJsonList = prefs.getStringList('cached_customers') ?? [];

    final loadedData = customerJsonList
        .map((jsonStr) => CustomerModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    if (mounted) {
      setState(() {
        customerData = loadedData;
        filteredData = List.from(customerData);
      });
    }
  }

  /// 🔍 Universal search filter
  void filterCustomer(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredData = customerData.where((item) {
        return (item.id ?? '').toLowerCase().contains(lowerQuery) ||
            (item.name ?? '').toLowerCase().contains(lowerQuery) ||
            (item.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (item.email ?? '').toLowerCase().contains(lowerQuery) ||
            (item.address ?? '').toLowerCase().contains(lowerQuery) ||
            (item.businessName ?? '').toLowerCase().contains(lowerQuery) ||
            (item.businessRepresentative ?? '')
                .toLowerCase()
                .contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Search Bar
              CustomerSearchBar(
                customerData: customerData,
                onSearchResult: (filteredList) {
                  setState(() => filteredData = filteredList);
                },
                onChanged: filterCustomer,
                onMicPressed: () {},
                onSearchChanged: filterCustomer,
              ),

              const SizedBox(height: 12),

              // ⚠️ Error message
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                ),

              const SizedBox(height: 10),

              // 📋 Customer Grid View
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredData.isEmpty
                        ? const Center(
                            child: Text(
                              'No customer data found.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 600;
                              return GridView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWide ? 2 : 1,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
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
      ),
    );
  }
}
