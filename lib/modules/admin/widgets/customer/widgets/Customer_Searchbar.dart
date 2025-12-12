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
    final theme = Theme.of(context);
    final availableWidth = MediaQuery.of(context).size.width;
    final compactWidth = 200.0;
    final targetWidth = _isFocused ? availableWidth * 0.93 : compactWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            if (!_isFocused)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Customer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Animated, responsive search bar (design-matched)
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: targetWidth.clamp(150.0, constraints.maxWidth),
                height: _isFocused ? 44 : 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: _isFocused ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        _isFocused ? theme.colorScheme.primary : Colors.black26,
                    width: _isFocused ? 1.4 : 1.0,
                  ),
                  boxShadow: _isFocused
                      ? [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Prefix: search icon or back arrow (tappable)
                    GestureDetector(
                      onTap: () {
                        if (_isFocused) {
                          _focusNode.unfocus();
                          _clearSearch();
                        } else {
                          _focusNode.requestFocus();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          _isFocused ? Icons.arrow_back : Icons.search,
                          size: 20,
                        ),
                      ),
                    ),

                    // Text field
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: widget.onSearchChanged,
                        cursorHeight: 20,
                        style:theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center, 
                        decoration: InputDecoration(
                          hintText: 'Search Customer By Name,Email',
                          hintStyle: TextStyle(
                            fontSize: 14, 
                            color: Colors.grey,
                            height:1.0, 
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    // Suffix: mic + logo when empty, clear when typing
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 36, maxWidth: 110),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchController.text.isEmpty) ...[
                            IconButton(
                              icon: const Icon(Icons.mic, size: 18),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: widget.onMicPressed,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  'assets/images/tosmall_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ] else ...[
                            IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: _clearSearch,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
