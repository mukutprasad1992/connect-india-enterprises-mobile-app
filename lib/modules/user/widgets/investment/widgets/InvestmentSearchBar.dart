import 'package:flutter/material.dart';
import '/models/investmentModel.dart';

class InvestmentSearchBar extends StatefulWidget {
  final List<InvestmentModel> investmentData;
  final Function(List<InvestmentModel>) onSearchResult;
  final VoidCallback onMicPressed;

  const InvestmentSearchBar({
    super.key,
    required this.investmentData,
    required this.onSearchResult,
    required this.onMicPressed,
  });

  @override
  State<InvestmentSearchBar> createState() => _InvestmentSearchBarState();
}

class _InvestmentSearchBarState extends State<InvestmentSearchBar> {
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

    final filtered = widget.investmentData.where((investment) {
      final placeOfBirthStr = (investment.placeOfBirth['city'] ??
              investment.placeOfBirth['place'] ??
              investment.placeOfBirth.toString())
          .toString()
          .toLowerCase();

      return investment.investmentType.toLowerCase().contains(lowerQuery) ||
          investment.panNumber.toLowerCase().contains(lowerQuery) ||
          investment.aadharNumber.toLowerCase().contains(lowerQuery) ||
          investment.email.toLowerCase().contains(lowerQuery) ||
          investment.mobile.toLowerCase().contains(lowerQuery) ||
          investment.amount.toLowerCase().contains(lowerQuery) ||
          investment.income.toLowerCase().contains(lowerQuery) ||
          investment.occupation.toLowerCase().contains(lowerQuery) ||
          placeOfBirthStr.contains(lowerQuery) ||
          (investment.nomineeMobile?.toLowerCase().contains(lowerQuery) ??
              false) ||
          investment.status.toLowerCase().contains(lowerQuery);
    }).toList();

    widget.onSearchResult(filtered);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchResult(widget.investmentData);
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
                  'Investments',
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
                              widget.onSearchResult(widget.investmentData);
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
