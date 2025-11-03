import 'package:flutter/material.dart';

class VoucherCustomerSearch extends StatefulWidget {
  final void Function(String searchText) onChanged;
  final List<Map<String, dynamic>> voucherData;
  final Function(List<Map<String, dynamic>>) onSearchResult;
  final Function(String) onSearchChanged;
  final VoidCallback onMicPressed;

  const VoucherCustomerSearch({
    super.key,
    required this.onChanged,
    required this.voucherData,
    required this.onSearchResult,
    required this.onMicPressed,
    required this.onSearchChanged,
  });

  @override
  State<VoucherCustomerSearch> createState() => _VoucherCustomerSearchState();
}

class _VoucherCustomerSearchState extends State<VoucherCustomerSearch> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      _filterData();
      setState(() {}); // To update suffix icons dynamically
    });

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  /// Filter voucher list based on user query
  void _filterData() {
    final query = searchController.text.toLowerCase();

    final filtered = widget.voucherData.where((row) {
      return row.values.any((val) {
        if (val == null) return false;
        return val.toString().toLowerCase().contains(query);
      });
    }).toList();

    widget.onSearchResult(filtered);
    widget.onChanged(query);
  }

  void _clearSearch() {
    searchController.clear();
    widget.onChanged('');
    widget.onSearchResult(widget.voucherData);
    _focusNode.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final inputWidth = _isFocused ? availableWidth * 0.9 : 220.0;

        return Row(
          children: [
            if (!_isFocused)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Customers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: inputWidth.clamp(160.0, availableWidth),
              height: _isFocused ? 44 : 36,
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
                controller: searchController,
                focusNode: _focusNode,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        height: _isFocused ? 1.4 : 2.0,
                      ),
                  prefixIcon: _isFocused
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            _focusNode.unfocus();
                            searchController.clear();
                            widget.onSearchChanged('');
                            setState(() {});
                          },
                        )
                      : const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (searchController.text.isEmpty) ...[
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
                      if (searchController.text.isNotEmpty)
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
