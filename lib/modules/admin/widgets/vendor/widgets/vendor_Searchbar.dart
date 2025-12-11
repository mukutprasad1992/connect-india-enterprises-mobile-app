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
      return row.values.any((val) => val.toLowerCase().contains(query));
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
                    'Vendor',
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
                                _searchController.clear();
                                widget.onSearchChanged('');
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
                          ? const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12)
                          : const EdgeInsets.only(top: 18, left: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                
                      // ⚠ Fix applied here
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    )
                  ),
              ),
            ),
          ],
        );
      },
    );
  }
}
