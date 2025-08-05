import 'package:flutter/material.dart';
import '/consts/appColors.dart';
class VendorDrawer extends StatelessWidget {
  final Map<String, bool> columnVisibility;
  final TextEditingController searchController;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final void Function(String column, bool? value) onCheckboxChanged;
  final VoidCallback onToggleAll;
  final VoidCallback onReset;

  const VendorDrawer({
    super.key,
    required this.columnVisibility,
    required this.searchController,
    required this.searchText,
    required this.onSearchChanged,
    required this.onCheckboxChanged,
    required this.onToggleAll,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final filteredKeys = columnVisibility.keys
        .where((key) => key.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    bool allSelected = columnVisibility.values.every((visible) => visible);

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search columns',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 400,
                child: ListView(
                  shrinkWrap: true,
                  children: filteredKeys.map((column) {
                    return CheckboxListTile(
                      value: columnVisibility[column],
                      title: Text(column),
                      activeColor: Colors.indigo,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) => onCheckboxChanged(column, value),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: onToggleAll,
                    icon: const Icon(Icons.toggle_on, color: Colors.white),
                    label: const Text('Show/Hide All',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                  ),
                  TextButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.reset_tv, color: Colors.white),
                    label: const Text('Reset',
                        style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor:AppColors.background,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
