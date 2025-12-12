import 'package:flutter/material.dart';

class VendorSearchBar extends StatefulWidget {
  final void Function(String searchText) onChanged;
  final List<Map<String, dynamic>> vendorData;
  final Function(List<Map<String, dynamic>>) onSearchResult;
  final Function(String) onSearchChanged;
  final VoidCallback onMicPressed;

  const VendorSearchBar({
    super.key,
    required this.onChanged,
    required this.vendorData,
    required this.onSearchResult,
    required this.onMicPressed,
    required this.onSearchChanged,
  });

  @override
  State<VendorSearchBar> createState() => _VendorSearchBarState();
}

class _VendorSearchBarState extends State<VendorSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _filterData();
      setState(() {});
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    final filtered = widget.vendorData.where((row) {
      return row.values.any((val) =>
          val.toString().toLowerCase().contains(query)); // safe toString()
    }).toList();

    widget.onSearchResult(filtered);
    widget.onChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onChanged('');
    widget.onSearchResult(widget.vendorData);
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
    final theme = Theme.of(context);
    final availableWidth = MediaQuery.of(context).size.width;
    // compact width when not focused; expands when focused
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
                    'Vendor',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            // Use Flexible so AnimatedContainer width doesn't conflict with Row
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: targetWidth.clamp(150.0, constraints.maxWidth),
                height: _isFocused ? 40 : 36,
                decoration: BoxDecoration(
                  color: _isFocused ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        _isFocused ? theme.colorScheme.primary : Colors.black12,
                    width: _isFocused ? 1.4 : 1.2,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // Compact prefix area (search icon or back arrow)
                    GestureDetector(
                      onTap: () {
                        if (_isFocused) {
                          _focusNode.unfocus();
                          _searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
                        } else {
                          // focus when tapping search icon
                          _focusNode.requestFocus();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Icon(
                          _isFocused ? Icons.arrow_back : Icons.search,
                          size: 20,
                        ),
                      ),
                    ),

                    // Input (fills remaining space)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: widget.onSearchChanged,
                        cursorHeight: 20,
                        style:
                          theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search Vendor by email, mobileNo',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.0,
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
                    // Suffix area (mic/logo OR clear)
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
