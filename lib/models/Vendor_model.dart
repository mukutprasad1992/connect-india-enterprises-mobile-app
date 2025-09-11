class Vendor {
  final int id;
  final String email;
  final String mobileNo;
  final String businessName;
  final String businessRepresentative;
  final String address;
  final String vendorCode;
  final String status;
  final DateTime createdAt;

  Vendor({
    required this.id,
    required this.email,
    required this.mobileNo,
    required this.businessName,
    required this.businessRepresentative,
    required this.address,
    required this.vendorCode,
    required this.status,
    required this.createdAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      email: json['email'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      businessName: json['businessName'] ?? '',
      businessRepresentative: json['businessRepresentative'] ?? '',
      address: json['address'] ?? '',
      vendorCode: json['vendorCode'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// ✅ Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobileNo': mobileNo,
      'businessName': businessName,
      'businessRepresentative': businessRepresentative,
      'address': address,
      'vendorCode': vendorCode,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
