import 'package:flutter/material.dart';
import '/models/insuranceModel.dart';

class InsuranceSearchBar extends StatefulWidget {
  final List<InsuranceModel> insuranceData;
  final Function(List<InsuranceModel>) onSearchResult;
  final VoidCallback onMicPressed;

  const InsuranceSearchBar({
    super.key,
    required this.insuranceData,
    required this.onSearchResult,
    required this.onMicPressed,
  });

  @override
  State<InsuranceSearchBar> createState() => _InsuranceSearchBarState();
}

class _InsuranceSearchBarState extends State<InsuranceSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _filterData(_searchController.text);
      setState(() {});
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void _filterData(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = widget.insuranceData.where((insurance) {
      final placeOfBirthStr = (insurance.placeOfBirth['city'] ??
              insurance.placeOfBirth['place'] ??
              insurance.placeOfBirth.toString())
          .toString()
          .toLowerCase();

      return insurance.insuranceType.toLowerCase().contains(lowerQuery) ||
          insurance.panNumber.toLowerCase().contains(lowerQuery) ||
          insurance.aadharNumber.toLowerCase().contains(lowerQuery) ||         
          insurance.income.toLowerCase().contains(lowerQuery) ||
          insurance.occupation.toLowerCase().contains(lowerQuery) ||
          placeOfBirthStr.contains(lowerQuery) ||
          insurance.status.toLowerCase().contains(lowerQuery);
    }).toList();

    widget.onSearchResult(filtered);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchResult(widget.insuranceData);
    _focusNode.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;

        return Row(
          children: [
            if (!_isFocused)
              Expanded(
                child: Text(
                  'Insurance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
              ),
            Expanded(
              flex: _isFocused ? 2 : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 38,
                width: _isFocused ? availableWidth : 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  
                  border: Border.all(
                      color: _isFocused
                          ? Colors.black.withOpacity(0.7)
                          : Colors.black,
                      width: _isFocused ? 1.5 : 1),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search by type, PAN, Aadhaar...',
                    hintStyle: TextStyle(
                      fontSize: _isFocused ? 12 : 12,
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: _isFocused
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back, size: 18),
                            onPressed: () {
                              _focusNode.unfocus();
                              _searchController.clear();
                              widget.onSearchResult(widget.insuranceData);
                              setState(() {});
                            },
                          )
                        : const Icon(Icons.search, size: 18),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isEmpty) ...[
                          IconButton(
                            icon: const Icon(Icons.mic, size: 18),
                            onPressed: widget.onMicPressed,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.asset(
                              'assets/images/tosmall_logo.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: _clearSearch,
                          ),
                      ],
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    filled: true,
                    //fillColor: Colors.grey.shade100,
                    fillColor:Colors.transparent, 
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
