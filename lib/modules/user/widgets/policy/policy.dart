// import 'package:flutter/material.dart';

// class PolicyPage extends StatefulWidget {
//   const PolicyPage({super.key});

//   @override
//   State<PolicyPage> createState() => _PolicyPageState();
// }
// class _PolicyPageState extends State<PolicyPage> {
//   // Variables and controllers go here

//   @override
//   void initState() {
//     super.initState();
//     // Initialize data or controllers here
//   }

//   @override
//   void dispose() {
//     // Dispose controllers or streams here
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Insurance Page"),
//       ),
//       body: const Center(
//         child: Text("This is the Insurance Page"),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/InsuranceSummaryCard.dart';
import 'widgets/InsuranceSearchBar.dart';
import '/models/insuranceModel.dart';
import '../../../../services/user_module_service_Api/insuranceServices/getInsuranceData.dart';
import '/modules/user/widgets/insurance/widgets/form_insurance/insuranceType.dart';

class PolicyPage extends StatefulWidget {
  final String token;
  const PolicyPage({super.key, required this.token});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  final TextEditingController _searchController = TextEditingController();
  List<InsuranceModel> insuranceData = [];
  List<InsuranceModel> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInsuranceFromApi();
    _searchController.addListener(_applySearchFilter);
  }

  /// Fetch Insurance from API with saved token
  Future<void> _fetchInsuranceFromApi() async {
    setState(() => isLoading = true);

    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : (await SharedPreferences.getInstance()).getString("KEYTOKEN");

      if (token == null) {
        _redirectToLogin();
        return;
      }

      const serviceId = "3";
      final response = await getAllInsurance.getAllInsuranceByServiceId(
        serviceId: serviceId,
        token: token,
      );

      //print("API response: $response");

      final data = response["data"];
      List<InsuranceModel> loadedData = [];

      if (data is List) {
        loadedData = data
            .map((json) =>
                InsuranceModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else if (data is Map) {
        loadedData = [InsuranceModel.fromJson(Map<String, dynamic>.from(data))];
      }

      setState(() {
        insuranceData = loadedData;
        filteredData = List.from(loadedData);
      });

      await saveInsurance();
    } catch (e) {
      //debugPrint(" API fetch failed: $e");
      await _loadInsurance();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> saveInsurance() async {
    final prefs = await SharedPreferences.getInstance();
    final insuranceJsonList =
        insuranceData.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('insurance', insuranceJsonList);
  }

  /// Load Insurance from local storage
  Future<void> _loadInsurance() async {
    final prefs = await SharedPreferences.getInstance();
    final insuranceJsonList = prefs.getStringList('insurances') ?? [];
    final loadedData = insuranceJsonList
        .map((jsonStr) => InsuranceModel.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      insuranceData = loadedData;
      filteredData = List.from(insuranceData);
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
      filteredData = insuranceData.where((insurance) {
        return insurance.nomineeName.toLowerCase().contains(query) ||
            insurance.aadharNumber.toLowerCase().contains(query);
      }).toList();
    });
  }

  /// Add new insurance
  void addNewInsurance(InsuranceModel newInsurance) {
    setState(() {
      insuranceData.insert(0, newInsurance);
    });
    saveInsurance();
    _applySearchFilter();
  }

  /// Update Insurance
  void _updateInsurance(int index, InsuranceModel updatedInsurance) {
    setState(() {
      insuranceData[index] = updatedInsurance;
    });
    saveInsurance();
    _applySearchFilter();
  }

  /// Delete Insurance
  void _deleteInsurance(int index) {
    setState(() {
      insuranceData.removeAt(index);
    });
    saveInsurance();
    _applySearchFilter();
  }

  void submitNewInsurance(Map<String, dynamic> insuranceData) {
    final newInsurance = InsuranceModel.fromJson(insuranceData);
    addNewInsurance(newInsurance);
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
                    InsuranceSearchBar(
                      insuranceData: insuranceData,
                      onSearchResult: (filteredList) {
                        setState(() {
                          filteredData = filteredList;
                        });
                      },
                      onMicPressed: () {},
                    ),
                    const SizedBox(height: 10),

                    // Insurance list
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : RefreshIndicator(
                              onRefresh: _fetchInsuranceFromApi,
                              child: filteredData.isEmpty
                                  ? const Center(
                                      child:
                                          Text('No Insurance data available.'))
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
                                        final insurance = filteredData[index];
                                        return InsuranceSummaryCard(
                                          row: insurance.toJson(),
                                          index: index,
                                          token: widget.token,
                                          onUpdate: (updatedInsurance) =>
                                              _updateInsurance(
                                                  index,
                                                  InsuranceModel.fromJson(
                                                      updatedInsurance)),
                                          onDelete: () =>
                                              _deleteInsurance(index),
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
                    onPressed: () {
                      showInsuranceTypeDialog(
                        context: context,
                        mode: "add",
                        token: widget.token,
                        submit: "1",
                        onSubmit: (insuranceData) async {
                          setState(() => isLoading = true);
                          try {
                            submitNewInsurance(insuranceData);
                            await Future.delayed(const Duration(seconds: 1));
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                      );
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
