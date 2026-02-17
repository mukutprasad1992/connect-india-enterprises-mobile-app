import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/loanSearchBar.dart';
import 'widgets/loanSummaryCard.dart';
import '/models/loanModel.dart';
import '../../../../services/user_module_service_Api/loanServices/getAllLoan.dart';
import '/modules/user/widgets/loan/widgets/form_loan/loanType.dart';

class LoanPage extends StatefulWidget {
  final String token;
  const LoanPage({super.key, required this.token});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  final TextEditingController _searchController = TextEditingController();
  List<LoanModel> loanData = [];
  List<LoanModel> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLoanFromApi();
    _searchController.addListener(_applySearchFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetch loan from API with saved token
  Future<void> _fetchLoanFromApi() async {
    setState(() => isLoading = true);

    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : (await SharedPreferences.getInstance()).getString("KEYTOKEN");

      if (token == null) {
        _redirectToLogin();
        return;
      }
      const serviceId = "4";
      final response = await GetAllLoan.getAllLoanByServiceId(
        serviceId: serviceId,
        token: token,
      );

      final data = response["data"];
      List<LoanModel> loadedData = [];

      if (data is List) {
        loadedData = data
            .map((json) => LoanModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else if (data is Map) {
        loadedData = [LoanModel.fromJson(Map<String, dynamic>.from(data))];
      }

      setState(() {
        loanData = loadedData;
        filteredData = List.from(loadedData);
      });

      await saveLoan();
    } catch (e) {
      await _loadLoan();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> saveLoan() async {
    final prefs = await SharedPreferences.getInstance();
    final loanJsonList = loanData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('loan', loanJsonList);
  }

  /// Load loan from local storage
  Future<void> _loadLoan() async {
    final prefs = await SharedPreferences.getInstance();
    final loanJsonList = prefs.getStringList('loan') ?? [];
    final loadedData = loanJsonList
        .map((jsonStr) => LoanModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      loanData = loadedData;
      filteredData = List.from(loanData);
    });
  }

  void _redirectToLogin() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredData = List.from(loanData);
        return;
      }

      filteredData = loanData.where((loan) {
        final loanType = loan.loanType?.toString().toLowerCase() ?? '';
        final pan = loan.panNumber?.toLowerCase() ?? '';
        final aadhar = loan.aadharNumber?.toLowerCase() ?? '';
        final motherName = loan.motherName?.toLowerCase() ?? '';
        final maritalStatus = loan.maritalStatus?.toLowerCase() ?? '';
        final currentAddress = loan.currentAddress?.toLowerCase() ?? '';
        final altNo = loan.alternateNo?.toLowerCase() ?? '';
        final ref1Name = loan.ref1Name?.toLowerCase() ?? '';
        final ref2Name = loan.ref2Name?.toLowerCase() ?? '';
        final ref1Mobile = loan.ref1Mobile?.toLowerCase() ?? '';
        final ref2Mobile = loan.ref2Mobile?.toLowerCase() ?? '';

        return loanType.contains(query) ||
            pan.contains(query) ||
            aadhar.contains(query) ||
            motherName.contains(query) ||
            maritalStatus.contains(query) ||
            currentAddress.contains(query) ||
            altNo.contains(query) ||
            ref1Name.contains(query) ||
            ref2Name.contains(query) ||
            ref1Mobile.contains(query) ||
            ref2Mobile.contains(query);
      }).toList();
    });
  }

  /// Add new loan
  void addNewLoan(LoanModel newLoan) {
    setState(() {
      loanData.insert(0, newLoan);
    });
    saveLoan();
    _applySearchFilter();
  }

  /// Update loan
  void _updateLoan(int index, LoanModel updatedLoan) {
    setState(() {
      loanData[index] = updatedLoan;
    });
    saveLoan();
    _applySearchFilter();
    _fetchLoanFromApi();
  }

  /// Delete loan
  void _deleteLoan(int index) {
    setState(() {
      loanData.removeAt(index);
    });
    saveLoan();
    _applySearchFilter();
    _fetchLoanFromApi();
  }

  void submitNewLoan(Map<String, dynamic> loandata) {
    final newLoan = LoanModel.fromJson(loandata);
    addNewLoan(newLoan);
    _fetchLoanFromApi();
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
                    LoanSearchBar(
                      loanData: loanData,
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList;
                        });
                      },
                      onMicPressed: () {},
                    ),

                    const SizedBox(height: 10),

                    // Loan list
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh:_fetchLoanFromApi, // Swipe down to refresh
                              child: filteredData.isEmpty
                                  ? const Center(
                                      child: Text('No Loan data available.'))
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isWideScreen ? 2 : 1,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio:
                                            isWideScreen ? 2.8 : 2.1,
                                      ),
                                      itemCount: filteredData.length,
                                      itemBuilder: (context, index) {
                                        final loan = filteredData[index];
                                        return LoanSummaryCard(
                                          row: loan.toJson(),
                                          index: index,
                                          token: widget.token,
                                          onUpdate: (updatedLoan) =>
                                              _updateLoan(
                                            index,
                                            LoanModel.fromJson(updatedLoan),
                                          ),
                                          onDelete: () => _deleteLoan(index),
                                          onReloadParent: () async {
                                            await _fetchLoanFromApi();
                                          },
                                        );
                                      },
                                    ),
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
                    // onPressed: () async {
                    //   await showLoanTypeDialog(
                    //     context: context,
                    //     mode: "add",
                    //     token: widget.token,
                    //     submit: "1",
                    //     onSubmit: (loandata) async {
                    //       // Show temporary loader
                    //       setState(() => isLoading = true);

                    //       try {
                    //         submitNewLoan(loandata);
                    //         await Future.delayed(const Duration(seconds: 1)); 
                    //       } 
                    //       finally {
                    //         setState(() => isLoading = false);
                    //       }
                    //     },
                    //   );
                    // },

                    onPressed: () async {
                      // Open the dialog + stepper and wait for its result (true = final submit success)
                      final bool? created = await showLoanTypeDialog(
                        context: context,
                        mode: "add",
                        token: widget.token,
                        submit: "1",
                        onSubmit: (loandata) {
                          // optional optimistic local insert
                          submitNewLoan(loandata);
                        },
                        // This callback will be called by Stepper whenever any section is saved successfully
                        onAnySectionSaved: () async {
                          if (mounted) setState(() => isLoading = true);
                          await _fetchLoanFromApi();
                          if (mounted) setState(() => isLoading = false);
                        },
                      );

                      // If the Stepper reported final success (user submitted), ensure we refresh once more
                      if (created == true) {
                        if (mounted) setState(() => isLoading = true);
                        await _fetchLoanFromApi();
                        if (mounted) setState(() => isLoading = false);
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
              )
            ],
          );
        },
      ),
    );
  }
}
