class VendorCustomerModel {
  String? id;
  String? name;
  String? address;
  String? phone;
  String? email;
  String? pincode;

  VendorCustomerModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.pincode,
  });

  factory VendorCustomerModel.fromJson(Map<String, dynamic> json) {
    return VendorCustomerModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'pincode': pincode,
    };
  }
}
