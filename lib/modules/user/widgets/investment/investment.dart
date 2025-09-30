import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//import '/modules/user/widgets/investment/widgets/form_investment/investment_form_page.dart';
import '/modules/user/widgets/investment/widgets/form_investment/investmentHorzontle.dart';
import 'widgets/InvestmentSummaryCard.dart';
import 'widgets/InvestmentSearchBar.dart';
import '/models/investmentModel.dart';
import '/services/serviceType/getdatabyserviceid.dart';

class InvestmentPage extends StatefulWidget {
  final String token;
  const InvestmentPage({
    super.key, 
    required this.token
  });

  @override
  State<InvestmentPage> createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  final TextEditingController _searchController = TextEditingController();
  List<InvestmentModel> investmentData = [];
  List<InvestmentModel> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInvestmentsFromApi();
    _searchController.addListener(_applySearchFilter);
  }

  /// Fetch investments from API with saved token
  Future<void> _fetchInvestmentsFromApi() async {
    setState(() => isLoading = true);

    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : (await SharedPreferences.getInstance()).getString("KEYTOKEN");

      if (token == null) {
        _redirectToLogin();
        return;
      }

      const serviceId = "1";
      final response = await ServiceTypeApi.getServiceTypeByServiceId(
        serviceId: serviceId,
        token: token,
      );

      print("API response: $response");

      final data = response["data"];
      List<InvestmentModel> loadedData = [];

      if (data is List) {
        loadedData = data
            .map((json) =>
                InvestmentModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else if (data is Map) {
        loadedData = [
          InvestmentModel.fromJson(Map<String, dynamic>.from(data))
        ];
      }

      setState(() {
        investmentData = loadedData;
        filteredData = List.from(loadedData);
      });

      await _saveInvestments();
    } catch (e) {
      debugPrint(" API fetch failed: $e");
      await _loadInvestments();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final investmentJsonList =
        investmentData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('investments', investmentJsonList);
  }

  /// Load investments from local storage
  Future<void> _loadInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final investmentJsonList = prefs.getStringList('investments') ?? [];
    final loadedData = investmentJsonList
        .map((jsonStr) => InvestmentModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      investmentData = loadedData;
      filteredData = List.from(investmentData);
    });
  }

  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredData = investmentData.where((investment) {
        return investment.amount.toLowerCase().contains(query) ||
            investment.aadharNumber.toLowerCase().contains(query);
      }).toList();
    });
  }

  /// Add new investment
  void _addNewInvestment(InvestmentModel newInvestment) {
    setState(() {
      investmentData.add(newInvestment);
    });
    _saveInvestments();
    _applySearchFilter();
  }

  /// Update investment
  void _updateInvestment(int index, InvestmentModel updatedInvestment) {
    setState(() {
      investmentData[index] = updatedInvestment;
    });
    _saveInvestments();
    _applySearchFilter();
  }

  /// Delete investment
  void _deleteInvestment(int index) {
    setState(() {
      investmentData.removeAt(index);
    });
    _saveInvestments();
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
                    // Search Bar
                    InvestmentSearchBar(
                      investmentData: investmentData,
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList;
                        });
                      },
                      onMicPressed: () {},
                    ),
                    const SizedBox(height: 10),

                    // Investment list
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredData.isEmpty
                              ? const Center(
                                  child: Text('No investment data available.'))
                              : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWideScreen ? 2 : 1,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: isWideScreen ? 2.8 : 2.1,
                                  ),
                                  itemCount: filteredData.length,
                                  itemBuilder: (context, index) {
                                    final investment = filteredData[index];
                                    return InvestmentSummaryCard(
                                      row: investment.toJson(),
                                      index: index,
                                      token: widget.token,
                                      onUpdate: (updatedInvestment) =>
                                          _updateInvestment(
                                              index,
                                              InvestmentModel.fromJson(
                                                  updatedInvestment)),
                                      onDelete: () => _deleteInvestment(index),
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
                      final newInvestment = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvestmentFormPage(
                            mode: "add",
                            token: widget.token,
                            submit: "1",
                          ),
                        ),
                      );
                      if (newInvestment != null &&
                          newInvestment is InvestmentModel) {
                        _addNewInvestment(newInvestment);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 24),
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
