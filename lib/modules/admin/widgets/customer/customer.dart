import 'package:flutter/material.dart';
import 'widgets/Customer_Searchbar.dart';
import 'widgets/customerSummaryCard.dart';

class CustomerTablePage extends StatefulWidget {
  const CustomerTablePage({super.key});

  @override
  State<CustomerTablePage> createState() => _CustomerTablePageState();
}

class _CustomerTablePageState extends State<CustomerTablePage> {
  List<Map<String, String>> customerData = [];
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadDummyCustomerData();
  }

  void _loadDummyCustomerData() {
    customerData = [
      {
        'ID': 'CUST-001',
        'Name': 'John Smith',
        'Email': 'john.smith@example.com',
        'Phone': '+1 555 111 2222',
        'Address': '101 Elm Street, Springfield',
        'Pin Code': '622001',
      },
      {
        'ID': 'CUST-002',
        'Name': 'Anil Kumar',
        'Email': 'anil.kumar@example.com',
        'Phone': '+91 98765 43210',
        'Address': '22 Gandhi Nagar, Delhi',
        'Pin Code': '110001',
      },
      {
        'ID': 'CUST-003',
        'Name': 'Sophia Lee',
        'Email': 'sophia.lee@example.com',
        'Phone': '+1 555 333 4444',
        'Address': '456 Maple Ave, Los Angeles',
        'Pin Code': '90001',
      },
      {
        'ID': 'CUST-004',
        'Name': 'Rajesh Mehta',
        'Email': 'rajesh.mehta@example.com',
        'Phone': '+91 91234 56789',
        'Address': 'B-12 Nehru Street, Mumbai',
        'Pin Code': '400001',
      },
      {
        'ID': 'CUST-005',
        'Name': 'Emma Watson',
        'Email': 'emma.watson@example.com',
        'Phone': '+44 7700 900123',
        'Address': '10 Queen’s Road, London',
        'Pin Code': 'W1A 1AA',
      },
      {
        'ID': 'CUST-006',
        'Name': 'Michael Jordan',
        'Email': 'mjordan@example.com',
        'Phone': '+1 555 555 5555',
        'Address': '23 Legend Street, Chicago',
        'Pin Code': '60601',
      },
      {
        'ID': 'CUST-007',
        'Name': 'Nina Sharma',
        'Email': 'nina.sharma@example.com',
        'Phone': '+91 99887 77665',
        'Address': '45 Lotus Park, Pune',
        'Pin Code': '411001',
      },
      {
        'ID': 'CUST-008',
        'Name': 'Carlos Rivera',
        'Email': 'carlos.rivera@example.com',
        'Phone': '+34 612 345 678',
        'Address': 'Calle Mayor 7, Madrid',
        'Pin Code': '28013',
      },
      {
        'ID': 'CUST-009',
        'Name': 'Chen Wei',
        'Email': 'chen.wei@example.cn',
        'Phone': '+86 138 0013 8000',
        'Address': '88 Beijing Road, Shanghai',
        'Pin Code': '200001',
      },
      {
        'ID': 'CUST-010',
        'Name': 'Fatima Zahra',
        'Email': 'fatima.zahra@example.ma',
        'Phone': '+212 661 234567',
        'Address': 'Rue Hassan II, Casablanca',
        'Pin Code': '20250',
      },
    ];
    //List<Map<String, String>> _filteredCustomerData = [];
    filteredData = customerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🕵️‍♂️ Search Bar
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

                // 🧾 Grid List
                Expanded(
                  child: filteredData.isEmpty
                      ? const Center(child: Text('No customer data found.'))
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
                            return CustomerSummaryCard(
                              row: row,
                              index: index,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
