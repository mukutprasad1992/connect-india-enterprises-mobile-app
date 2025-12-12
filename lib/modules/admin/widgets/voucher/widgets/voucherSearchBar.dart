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
                    'Voucher',
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
                  decoration: InputDecoration(
                    hintText: 'Search voucher...',
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
                              widget.onSearchChanged('');
                              setState(() {});
                            },
                          )
                        : const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isEmpty) ...[
                          // VoucherMic(
                          //   onResult: _handleMicResult,
                          // ),
                          IconButton(
                            icon: const Icon(Icons.mic, size: 18),
                            onPressed: widget.onMicPressed,
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.mic, size: 18),
                          //   onPressed: () {
                          //     _voucherMic.startListening(_handleMicResult);
                          //   },
                          // ),
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
