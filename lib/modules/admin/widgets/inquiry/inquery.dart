import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/Inquiry_Searchbar.dart';
import 'widgets/InquerySummaryCard.dart';
import '../../../../services/admin_module_service_Api/Inquiry/getAllServiceTypeInquirydata.dart';
import '/models/inquiryModel.dart';

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
  String searchText = '';

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
      final prefs = await SharedPreferences.getInstance();
      final token =
          widget.token.isNotEmpty ? widget.token : prefs.getString("KEYTOKEN");

      if (token == null || token.isEmpty) {
        _redirectToLogin();
        return;
      }

      final response = await InquiryService.getAllServiceTypes(token: token);
      final data = response["data"];

      List<InquiryModel> loadedData = [];

      if (data is List) {
        loadedData = data
            .map((json) => InquiryModel.fromJson(
                  Map<String, dynamic>.from(json),
                ))
            .toList();
      } else if (data is Map) {
        loadedData = [InquiryModel.fromJson(Map<String, dynamic>.from(data))];
      }

      setState(() {
        inquiryData = loadedData;
        filteredData = List.from(loadedData);
      });

      await _saveInquiry();
    } catch (e) {
      await _loadInquiry();
      setState(() {
        errorMessage = " Failed to load live data. Showing cached results.";
      });
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
      filteredData = List.from(loadedData);
    });
  }


  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }


  void _filterInquiries(String query) {
    setState(() {
      searchText = query.toLowerCase();
      filteredData = inquiryData.where((item) {
        return 
          item.id.toString().contains(query) ||
          (item.aadharNumber ?? '').toLowerCase().contains(query) ||
          (item.id ?? '').toLowerCase().contains(query) ||
          (item.panNumber ?? '').toLowerCase().contains(query) ||
          (item.status ?? '').toLowerCase().contains(query)||
          (item.serviceId ?? '').toLowerCase().contains(query);

      }).toList();
    });
  }


  void _onStatusChanged() {
    _fetchInquiryData(); 
  }

  
  void _setLoading(bool value) {
    if (mounted) {
      setState(() => isLoading = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                InquerySearchBar(
                  inquiryData: inquiryData,
                  onChanged: _filterInquiries,
                  onSearchResult: (filteredList) {
                    setState(() => filteredData = filteredList);
                  },
                  onMicPressed: () {},
                  onSearchChanged: _filterInquiries,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredData.isEmpty
                          ? Center(
                              child: Text(
                                errorMessage.isNotEmpty
                                    ? errorMessage
                                    : 'No inquiry data available.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _fetchInquiryData,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isWideScreen ? 2 : 1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: isWideScreen ? 2.8 : 2,
                                ),
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  final row = filteredData[index];
                                  return InquirySummaryCard(
                                    token: widget.token,
                                    row: row,
                                    onStatusChanged: _onStatusChanged,
                                    setLoading: _setLoading,
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
