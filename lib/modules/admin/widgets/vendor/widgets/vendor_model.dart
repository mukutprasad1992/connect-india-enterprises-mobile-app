// class Vendor {
//   final String BusinessName;
//   final String BusinessRepresentative;
//   final String email;
//   final String phone;
//   final String vendorCode;
//   final String address;
//   final String status;

//   Vendor({
//     required this.BusinessName,
//     required this.BusinessRepresentative,
//     required this.email,
//     required this.phone,
//     required this.vendorCode,
//     required this.address,
//     required this.status,
//   });

//   factory Vendor.fromMap(Map<String, dynamic> map) {
//     return Vendor(
//       BusinessName: map['BusinessName'] ?? '',
//       BusinessRepresentative: map['BusinessRepresentative'] ?? '',
//       email: map['Email'] ?? '',
//       phone: map['Phone'] ?? '',
//       vendorCode: map['VendorCode'] ?? '',
//       address: map['Address'] ?? '',
//       status: map['Status'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'BusinessName': BusinessName,
//       'BusinessRepresentative': BusinessRepresentative, 
//       'Email': email,
//       'Phone': phone,
//       'VendorCode': vendorCode,
//       'Address': address,
//       'Status': status,
//     };
//   }
// }
