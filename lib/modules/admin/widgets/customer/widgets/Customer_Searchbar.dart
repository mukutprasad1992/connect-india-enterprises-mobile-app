import 'package:flutter/material.dart';
import '/models/customerModel.dart';

class CustomerSearchBar extends StatefulWidget {
  final List<CustomerModel> customerData;
  final Function(List<CustomerModel>) onSearchResult;
  final void Function(String searchText) onChanged;
  final Function(String) onSearchChanged;
  final VoidCallback onMicPressed;

  const CustomerSearchBar({
    super.key,
    required this.customerData,
    required this.onSearchResult,
    required this.onMicPressed,
    required this.onSearchChanged,
    required this.onChanged,
  });

  @override
  State<CustomerSearchBar> createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends State<CustomerSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterData);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  /// Filters the customer list based on the entered text.
  void _filterData() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      widget.onSearchResult(widget.customerData);
      return;
    }

    final filtered = widget.customerData.where((customer) {
      return [
        customer.id?.toString(),
        customer.name,
        customer.email,
        customer.phone,
        customer.address,
        customer.pinCode,
        customer.businessName,
        customer.businessRepresentative
      ].any((field) => field?.toLowerCase().contains(query) ?? false);
    }).toList();

    widget.onSearchResult(filtered);
    widget.onChanged(query);
  }

  /// Clears the current search query and resets the list
  void _clearSearch() {
    _searchController.clear();
    widget.onChanged('');
    widget.onSearchResult(widget.customerData);
    _focusNode.requestFocus();
    setState(() {}); // Refresh UI
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
                    'Customer',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),

            // 🔍 Animated Search Bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: inputWidth.clamp(150.0, availableWidth),
              height: _isFocused ? 42 : 34,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  controller: _searchController,
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
                              _clearSearch();
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),

                    filled: true,
                    fillColor: Colors.grey.shade100,

                    // ✔ REAL FIX – REMOVE ALL INNER BORDERS
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
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
