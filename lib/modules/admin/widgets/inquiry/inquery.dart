import 'package:flutter/material.dart';
import 'widgets/Inquiry_Searchbar.dart';

import 'widgets/InquerySummaryCard.dart';

class InqueryTablePage extends StatefulWidget {
  const InqueryTablePage({super.key});

  @override
  State<InqueryTablePage> createState() => _InqueryTablePageState();
}

class _InqueryTablePageState extends State<InqueryTablePage> {
  List<Map<String, String>> inquiryData = [];
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadDummyInquiryData();
  }

  void _loadDummyInquiryData() {
    inquiryData = [
      {
        'ID': '001',
        'First Name': 'John',
        'Last Name': 'Doe',
        'Email': 'john@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '100000',
        'Duration': '2 years',
        'Contact Timing': 'Morning',
        'Status': 'Pending',
      },
      {
        'ID': '002',
        'First Name': 'Pramod',
        'Last Name': 'Singh',
        'Email': 'pk@example.com',
        'Mobile No': '9876543210',
        'Type': 'Business',
        'Amount': '500000',
        'Duration': '3 years',
        'Contact Timing': 'Evening',
        'Status': 'Pending',
      },
      {
        'ID': '003',
        'First Name': 'Rajiv',
        'Last Name': 'Gupta',
        'Email': 'rajiv@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '75000',
        'Duration': '1 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Rejected',
      },
      {
        'ID': '004',
        'First Name': 'Ram Kailash ',
        'Last Name': 'kushwaha',
        'Email': 'ram@example.com',
        'Mobile No': '9284283432',
        'Type': 'Mutul fund',
        'Amount': '500000',
        'Duration': '2 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
      {
        'ID': '005',
        'First Name': 'Ajay',
        'Last Name': 'Kushwaha',
        'Email': 'ajay@example.com',
        'Mobile No': '8081920652',
        'Type': 'Term Insuarnce',
        'Amount': '200000',
        'Duration': '3 year',
        'Contact Timing': 'Evening',
        'Status': 'Pending',
      },
      {
        'ID': '006',
        'First Name': 'Antim',
        'Last Name': 'Kumar',
        'Email': 'antim@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '75000',
        'Duration': '1 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
      {
        'ID': '007',
        'First Name': 'Rajiv',
        'Last Name': 'Gupta',
        'Email': 'rajiv@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '75000',
        'Duration': '1 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
      {
        'ID': '008',
        'First Name': 'Rajiv',
        'Last Name': 'Gupta',
        'Email': 'rajiv@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '75000',
        'Duration': '1 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
      {
        'ID': '009',
        'First Name': 'Rajiv',
        'Last Name': 'Gupta',
        'Email': 'rajiv@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '75000',
        'Duration': '1 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
      {
        'ID': '010',
        'First Name': 'Deepak',
        'Last Name': 'Majhi',
        'Email': 'majhi@example.com',
        'Mobile No': '9876543210',
        'Type': 'Personal',
        'Amount': '5245000',
        'Duration': '5 year',
        'Contact Timing': 'Afternoon',
        'Status': 'Pending',
      },
    ];
    filteredData = inquiryData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                InquerySearchBar(
                  inquiryData: inquiryData,
                  onChanged: (text) {},
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
                      ? const Center(child: Text('No inquiry data available.'))
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWideScreen ? 2 : 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                isWideScreen ? 2.2 : 1.9, // smoother aspect
                          ),
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            final row = filteredData[index];
                            return InquirySummaryCard(
                              row: row,
                              onStatusChanged: () => setState(() {}),
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
