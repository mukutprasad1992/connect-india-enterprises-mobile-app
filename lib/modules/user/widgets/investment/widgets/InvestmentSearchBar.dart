import 'package:flutter/material.dart';
import '../widgets/investment_models/Investment_model.dart';

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
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  /// ✅ Filter by multiple fields
  void _filterData(String query) {
    final filtered = widget.investmentData.where((investment) {
      return investment.investmentType.toLowerCase().contains(query.toLowerCase()) ||
             investment.panNumber.toLowerCase().contains(query.toLowerCase()) ||
             investment.aadharNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();

    widget.onSearchResult(filtered);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchResult(widget.investmentData);
    _focusNode.requestFocus();
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
        double inputWidth = _isFocused ? availableWidth * 0.9 : 200;

        return Row(
          children: [
            if (!_isFocused)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Investments',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: inputWidth.clamp(150.0, availableWidth),
              height: _isFocused ? 42 : 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: _isFocused
                    ? [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search by type, Investment details...',
                  hintStyle: TextStyle(
                    fontSize: _isFocused ? 14 : 12,
                    color: Colors.grey,
                    height: _isFocused ? 1.4 : 2.0,
                  ),
                  prefixIcon: _isFocused
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _focusNode.unfocus();
                            _searchController.clear();
                            widget.onSearchResult(widget.investmentData);
                            setState(() {});
                          },
                        )
                      : const Icon(Icons.search),
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
                            width: 18,
                            height: 18,
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
                  contentPadding: _isFocused
                      ? const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
                      : const EdgeInsets.only(top: 18, left: 12),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
