import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/Inquiry_Searchbar.dart';
import 'widgets/InquerySummaryCard.dart';
import '/services/adminServiceApi/InquirydataApi.dart';
import 'widgets/InquiryModel/inquirymodel.dart';

class InqueryTablePage extends StatefulWidget {
  final String token;
  const InqueryTablePage({super.key, required this.token});

  @override
  State<InqueryTablePage> createState() => _InqueryTablePageState();
}

class _InqueryTablePageState extends State<InqueryTablePage> {
  List<InquiryModel> inquiryData = [];
  List<InquiryModel> filteredData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchInquiryData();
  }

  Future<void> _fetchInquiryData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : (await SharedPreferences.getInstance()).getString("KEYTOKEN");

      if (token == null) {
        _redirectToLogin();
        return;
      }

      final response = await ServiceTypeApi.getAllServiceType(token: token);
      final data = response["data"];

      List<InquiryModel> loadedData = [];

      if (data is List) {
        loadedData = data
            .map((json) =>
                InquiryModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else if (data is Map) {
        loadedData = [InquiryModel.fromJson(Map<String, dynamic>.from(data))];
      }

      setState(() {
        inquiryData = loadedData;
        filteredData = List.from(inquiryData);
      });

      await _saveInquiry();
    } catch (e) {
      debugPrint("API fetch failed: $e");
      await _loadInquiry();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveInquiry() async {
    final prefs = await SharedPreferences.getInstance();
    final inquiryJsonList =
        inquiryData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('inquiry', inquiryJsonList);
  }

  Future<void> _loadInquiry() async {
    final prefs = await SharedPreferences.getInstance();
    final inquiryJsonList = prefs.getStringList('inquiry') ?? [];

    final loadedData = inquiryJsonList
        .map((jsonStr) => InquiryModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      inquiryData = loadedData;
      filteredData = List.from(inquiryData);
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (errorMessage.isNotEmpty) {
            return Center(child: Text(errorMessage));
          }

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
                            childAspectRatio: isWideScreen ? 2.2 : 1.9,
                          ),
                          itemBuilder: (context, index) {
                            debugPrint("Building card $index of ${filteredData.length}");
                            if (index >= filteredData.length) {
                              return const SizedBox
                                  .shrink(); 
                            }

                            final row = filteredData[index];
                            return InquirySummaryCard(
                              token: widget.token,
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
