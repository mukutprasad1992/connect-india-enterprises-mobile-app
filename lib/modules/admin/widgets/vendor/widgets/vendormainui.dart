// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'new_vendorpage.dart';
// // import 'vendorIconbuttons.dart';
// // //import 'edit_page.dart';

// // class VendorTablePage extends StatefulWidget {
// //   const VendorTablePage({super.key});

// //   @override
// //   State<VendorTablePage> createState() => _VendorTablePageState();
// // }

// // class _VendorTablePageState extends State<VendorTablePage> {
// //   final TextEditingController searchController = TextEditingController();
// //   List<Map<String, String>> vendorData = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadVendors();
// //   }

// //   Future<void> _saveVendors() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final vendorJsonList =
// //         vendorData.map((vendor) => jsonEncode(vendor)).toList();
// //     await prefs.setStringList('vendors', vendorJsonList);
// //   }

// //   Future<void> _loadVendors() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final vendorJsonList = prefs.getStringList('vendors') ?? [];
// //     setState(() {
// //       vendorData = vendorJsonList
// //           .map((vendorJson) => Map<String, String>.from(jsonDecode(vendorJson)))
// //           .toList();
// //     });
// //   }

// //   void _addNewVendor(Map<String, String> newVendor) {
// //     setState(() {
// //       vendorData.add(newVendor);
// //     });
// //     _saveVendors();
// //   }

// //   void _updateVendor(int index, Map<String, String> updatedVendor) {
// //     setState(() {
// //       vendorData[index] = updatedVendor;
// //     });
// //     _saveVendors();
// //   }

// //   void _toggleVendorBlockStatus(int index, Map<String, String> updatedVendor) {
// //     setState(() {
// //       vendorData[index] = updatedVendor;
// //     });
// //     _saveVendors();
// //   }

// //   void _deleteVendor(int index) {
// //     setState(() {
// //       vendorData.removeAt(index);
// //     });
// //     _saveVendors();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final query = searchController.text.toLowerCase();
// //     final filteredData = vendorData.where((row) {
// //       return row.values.any((value) => value.toLowerCase().contains(query));
// //     }).toList();

// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Text(
// //                       'Vendor',
// //                       style:
// //                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     SizedBox(
// //                       width:220,
// //                       height: 30,
// //                       child: Container(
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(10),
// //                           // boxShadow: [
// //                           //   BoxShadow(
// //                           //     color: Colors.grey,
// //                           //     blurRadius: 6,
// //                           //     offset: const Offset(0, 2),
// //                           //   ),
// //                           // ],
// //                         ),
// //                         child: TextField(
// //                           controller: searchController,
// //                           decoration: InputDecoration(
// //                             hintText: 'search',
// //                             prefixIcon: const Icon(Icons.search),
// //                             suffixIcon: Padding(
// //                               padding: const EdgeInsets.only(right: 2),
// //                               child: SizedBox(
// //                                 width: 10,
// //                                 height: 10,
// //                                 child: Image.asset('assets/images/tosmall_logo.png',fit: BoxFit.contain,)
// //                               ),
// //                             ),
// //                             border: InputBorder.none,
// //                             contentPadding: const EdgeInsets.symmetric( horizontal: 12, vertical: 10),),
// //                           onChanged: (_) => setState(() {}),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 // Ensure parent Column is inside a SizedBox/Expanded/etc. if needed
// //                 Expanded(
// //                   child: filteredData.isEmpty
// //                       ? const Center(child: Text('No vendor data available.'))
// //                       : GridView.builder(
// //                           gridDelegate:
// //                               SliverGridDelegateWithFixedCrossAxisCount(
// //                             crossAxisCount:
// //                                 MediaQuery.of(context).size.width > 600 ? 2 : 1,
// //                             crossAxisSpacing: 12,
// //                             mainAxisSpacing: 12,
// //                             childAspectRatio: 2,
// //                           ),
// //                           itemCount: filteredData.length,
// //                           itemBuilder: (context, index) {
// //                             final row = filteredData[index];
// //                             return VendorSummaryCard(
// //                               row: row,
// //                               index: index,
// //                               onUpdate: _updateVendor,
// //                               onBlockToggle: _toggleVendorBlockStatus,
// //                               onDelete: _deleteVendor,
// //                             );
// //                           },
// //                         ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           // Fixed Add Button
// //           Positioned(
// //             bottom: 20,
// //             left: 0,
// //             right: 0,
// //             child: Center(
// //               child: ElevatedButton(
// //                 onPressed: () async {
// //                   final newVendor = await Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => NewVendorPage()),
// //                   );
// //                   if (newVendor != null && newVendor is Map<String, String>) {
// //                     _addNewVendor(newVendor);
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.deepPurple,
// //                   padding: const EdgeInsets.all(16),
// //                   shape: const CircleBorder(),
// //                 ),
// //                 child: const Icon(Icons.add, color: Colors.white, size: 28),
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class VendorSummaryCard extends StatelessWidget {
// //   final Map<String, String> row;
// //   final int index;
// //   final void Function(int, Map<String, String>) onUpdate;
// //   final void Function(int, Map<String, String>) onBlockToggle;
// //   final void Function(int) onDelete;

// //   const VendorSummaryCard({
// //     super.key,
// //     required this.row,
// //     required this.index,
// //     required this.onUpdate,
// //     required this.onBlockToggle,
// //     required this.onDelete,
// //   });

// //   Color _getStatusColor(String? status) {
// //     switch (status?.toLowerCase()) {
// //       case 'active':
// //         return Colors.green;
// //       case 'blocked':
// //         return Colors.redAccent;
// //       case 'pending':
// //         return Colors.orange;
// //       default:
// //         return Colors.grey;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final statusColor = _getStatusColor(row['Status']);
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.shade300,
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       padding: const EdgeInsets.all(14),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Top Row: Business Name and Actions
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 child: Text(
// //                   row['Business name'] ?? 'No Name',
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 16,
// //                     color: Colors.indigo,
// //                   ),
// //                 ),
// //               ),
// //               VendorActionButtons(
// //                 row: row,
// //                 index: index,
// //                 onUpdate: onUpdate,
// //                 onBlockToggle: onBlockToggle,
// //                 onDelete: onDelete,
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 12),

// //           // Line 1: Representative
// //           Text.rich(
// //             TextSpan(
// //               children: [
// //                 const TextSpan(
// //                   text: 'Representative: ',
// //                   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
// //                 ),
// //                 TextSpan(
// //                   text: row['Business representative'] ?? '',
// //                   style: const TextStyle(fontSize: 13, color: Colors.teal),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 6),

// //           // Line 2: Vendor Code
// //           Text.rich(
// //             TextSpan(
// //               children: [
// //                 const TextSpan(
// //                   text: 'Vendor Code: ',
// //                   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
// //                 ),
// //                 TextSpan(
// //                   text: row['Vendor code'] ?? '',
// //                   style: const TextStyle(fontSize: 13, color: Colors.blue),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 6),

// //           // Line 3: Status
// //           Text.rich(
// //             TextSpan(
// //               children: [
// //                 const TextSpan(
// //                   text: 'Status: ',
// //                   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
// //                 ),
// //                 TextSpan(
// //                   text: row['Status'] ?? '',
// //                   style: TextStyle(
// //                     color: statusColor,
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 13,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLabelValueText(String label, String value, Color valueColor) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label,
// //             style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.black54)),
// //         const SizedBox(height: 4),
// //         Text(value,
// //             style: TextStyle(
// //                 fontSize: 14, fontWeight: FontWeight.w500, color: valueColor)),
// //       ],
// //     );
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'generatepage.dart';
// import 'voucherIconbuttons.dart';

// class VoucherTablePage extends StatefulWidget {
//   const VoucherTablePage({super.key});

//   @override
//   State<VoucherTablePage> createState() => _VoucherTablePageState();
// }

// class _VoucherTablePageState extends State<VoucherTablePage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> voucherData = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadVouchers();
//   }

//   Future<void> _saveVouchers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final voucherJsonList = voucherData.map(jsonEncode).toList();
//     await prefs.setStringList('vouchers', voucherJsonList);
//   }

//   Future<void> _loadVouchers() async {
//     final prefs = await SharedPreferences.getInstance();
//     final voucherJsonList = prefs.getStringList('vouchers') ?? [];
//     setState(() {
//       voucherData = voucherJsonList
//           .map((jsonStr) => Map<String, dynamic>.from(jsonDecode(jsonStr)))
//           .toList();
//     });
//   }

//   void _updateVoucher(int index, Map<String, dynamic> updatedVoucher) {
//     setState(() {
//       voucherData[index] = updatedVoucher;
//     });
//     _saveVouchers();
//   }

//   void _toggleBlockStatus(int index) {
//     setState(() {
//       final currentStatus = voucherData[index]['Status'] ?? 'Active';
//       voucherData[index]['Status'] =
//           currentStatus == 'Blocked' ? 'Active' : 'Blocked';
//     });
//     _saveVouchers(); // Save to SharedPreferences
//   }

//   void _addNewVoucher(Map<String, dynamic> newVoucher) {
//     setState(() {
//       voucherData.add(newVoucher);
//     });
//     _saveVouchers();
//   }

//   void _deleteVoucher(int index) {
//     setState(() {
//       voucherData.removeAt(index);
//     });
//     _saveVouchers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = _searchController.text.toLowerCase();
//     final filteredData = voucherData.where((row) {
//       return row.values.any((value) => value.toLowerCase().contains(query));
//     }).toList();

//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Voucher',
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 16),
//                     SizedBox(
//                       width: 220,
//                       height: 30,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           // boxShadow: [
//                           //   BoxShadow(
//                           //     color: Colors.grey,
//                           //     blurRadius: 6,
//                           //     offset: const Offset(0, 2),
//                           //   ),
//                           // ],
//                         ),
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             hintText: 'search',
//                             prefixIcon: const Icon(Icons.search),
//                             suffixIcon: Padding(
//                               padding: const EdgeInsets.only(right: 2),
//                               child: SizedBox(
//                                   width: 10,
//                                   height: 10,
//                                   child: Image.asset(
//                                     'assets/images/tosmall_logo.png',
//                                     fit: BoxFit.contain,
//                                   )),
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 10),
//                           ),
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: filteredData.isEmpty
//                       ? const Center(child: Text('No voucher data available.'))
//                       : GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount:
//                                 MediaQuery.of(context).size.width > 600 ? 2 : 1,
//                             crossAxisSpacing: 12,
//                             mainAxisSpacing: 12,
//                             childAspectRatio: 2.1,
//                           ),
//                           itemCount: filteredData.length,
//                           itemBuilder: (context, index) {
//                             final row = filteredData[index];
//                             return VoucherCard(
//                               row: row,
//                               index: index,
//                               onUpdate: (updatedRow) =>
//                                   _updateVoucher(index, updatedRow),
//                               onBlockToggle: () => _toggleBlockStatus(index),
//                               onDelete: () => _deleteVoucher(index),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final newVoucher = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => GenerateVoucherPage()),
//                   );
//                   if (newVoucher != null &&
//                       newVoucher is Map<String, dynamic>) {
//                     _addNewVoucher(newVoucher);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   padding: const EdgeInsets.all(16),
//                   shape: const CircleBorder(),
//                 ),
//                 child: const Icon(Icons.add, color: Colors.white, size: 28),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class VoucherCard extends StatelessWidget {
//   final Map<String, dynamic> row;
//   final int index;
//   final VoidCallback onBlockToggle;
//   final ValueChanged<Map<String, dynamic>> onUpdate;
//   final VoidCallback onDelete;

//   const VoucherCard({
//     super.key,
//     required this.row,
//     required this.index,
//     required this.onDelete,
//     required this.onBlockToggle,
//     required this.onUpdate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     //print('isRedeemed = ${row['isRedeemed']}');
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.grey.shade300,
//               blurRadius: 4,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   row['customer'] ?? 'No Name',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.indigo,
//                   ),
//                 ),
//               ),
//               VoucherActionButtons(
//                 row: row,
//                 index: index,
//                 onUpdate: onUpdate,
//                 onBlockToggle: onBlockToggle,
//                 onDelete: onDelete,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),

//           _buildLabelValueText(
//               "Vendor Name", row['vendor'] ?? '', Colors.green),
//           const SizedBox(height: 6),
//           _buildLabelValueText("Voucher Code", row['code'] ?? '', Colors.blue),
//           const SizedBox(height: 6),
//           // if (row['Redeemed']?.toString() == 'true') ...[
//           //   _buildLabelValueText(
//           //     'Voucher Status',
//           //     'Redeemed',
//           //     Colors.orange,
//           //   ),
//           // ],

//           // if both data show redeem or not redeem //

//           _buildLabelValueText(
//             'Voucher Status',
//             row['Redeemed']?.toString() == 'true'
//                 ? '🎉 Voucher Redeemed'
//                 : '❗ Unclaimed Voucher!',
//             row['Redeemed']?.toString() == 'true'
//                 ? Color(0xFF4CAF50)
//                 :Colors.orange,
//                 //: Color(0xFFE53935),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabelValueText(String label, String value, Color valueColor) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: "$label: ",
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//               color: Colors.black87,
//             ),
//           ),
//           TextSpan(
//             text: value,
//             style: TextStyle(
//               fontSize: 13,
//               color: valueColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
