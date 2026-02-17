import 'package:flutter/material.dart';
//import 'voucherMic.dart';

class VoucherSearchBar extends StatefulWidget {
  final void Function(String searchText) onChanged;
  final List<Map<String, dynamic>> voucherData;
  final Function(List<Map<String, dynamic>>) onSearchResult;
  final VoidCallback onMicPressed;
  final Function(String) onSearchChanged;

  const VoucherSearchBar({
    super.key,
    required this.onChanged,
    required this.voucherData,
    required this.onSearchResult,
    required this.onMicPressed,
    required this.onSearchChanged,
  });

  @override
  State<VoucherSearchBar> createState() => _VoucherSearchBarState();
}

class _VoucherSearchBarState extends State<VoucherSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  //final VoucherMic _voucherMic = VoucherMic();

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
    final filtered = widget.voucherData.where((row) {
      return row.values.any(
          (val) => val.toString().toLowerCase().contains(query.toLowerCase()));
    }).toList();

    widget.onSearchResult(filtered);
    widget.onChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onChanged('');
    widget.onSearchResult(widget.voucherData);
    _focusNode.requestFocus();
    setState(() {});
  }

  // void _handleMicResult(String text) {
  //   _searchController.text = text;
  //   _filterData(text);
  // }

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
                    'Voucher',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Animated responsive search bar (design-matched)
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
                    // Prefix (search icon or back arrow)
                    GestureDetector(
                      onTap: () {
                        if (_isFocused) {
                          _focusNode.unfocus();
                          _searchController.clear();
                          widget.onSearchChanged('');
                          setState(() {});
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
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                        textAlignVertical:
                            TextAlignVertical.center, 
                        decoration: InputDecoration(
                          hintText: 'Search voucher By Customer Name',
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
                            // VoucherMic(
                            //   onResult: _handleMicResult,
                            // ),
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
