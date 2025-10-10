import 'package:flutter/material.dart';
import '/models/loanModel.dart';

class LoanSearchBar extends StatefulWidget {
  final List<LoanModel> loanData;
  final Function(List<LoanModel>) onSearchResult;
  final VoidCallback onMicPressed;

  const LoanSearchBar({
    super.key,
    required this.loanData,
    required this.onSearchResult,
    required this.onMicPressed,
  });

  @override
  State<LoanSearchBar> createState() => _LoanSearchBarState();
}

class _LoanSearchBarState extends State<LoanSearchBar> {
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

  /// 🔍 Filter logic for all LoanModel fields
  void _filterData(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      widget.onSearchResult(widget.loanData);
      return;
    }

    final filtered = widget.loanData.where((loan) {
      final loanType = loan.loanType?.toLowerCase() ?? '';
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

      return loanType.contains(lowerQuery) ||
          pan.contains(lowerQuery) ||
          aadhar.contains(lowerQuery) ||
          motherName.contains(lowerQuery) ||
          maritalStatus.contains(lowerQuery) ||
          currentAddress.contains(lowerQuery) ||
          altNo.contains(lowerQuery) ||
          ref1Name.contains(lowerQuery) ||
          ref2Name.contains(lowerQuery) ||
          ref1Mobile.contains(lowerQuery) ||
          ref2Mobile.contains(lowerQuery);
    }).toList();

    widget.onSearchResult(filtered);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchResult(widget.loanData);
    _focusNode.unfocus();
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
                  'Loans',
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
                        ? Colors.deepPurple.withOpacity(0.7)
                        : Colors.grey.shade300,
                    width: _isFocused ? 1.5 : 1,
                  ),
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
                    hintText:
                        'Search by name, type, PAN, Aadhaar, or mobile...',
                    hintStyle: TextStyle(
                      fontSize: _isFocused ? 14 : 12,
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: _isFocused
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back, size: 18),
                            onPressed: () {
                              _clearSearch();
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
                    fillColor: Colors.transparent,
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
