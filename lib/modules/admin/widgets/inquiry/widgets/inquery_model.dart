class InquiryModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String status;

  InquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
  });

  factory InquiryModel.fromMap(Map<String, dynamic> map) {
    return InquiryModel(
      id: map['ID'] ?? '',
      name: map['Name'] ?? '',
      email: map['Email'] ?? '',
      phone: map['Phone'] ?? '',
      address: map['Address'] ?? '',
      status: map['Status'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'ID': id,
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Address': address,
      'Status': status,
    };
  }
}
