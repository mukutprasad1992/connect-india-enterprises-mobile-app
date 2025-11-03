class CustomerModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? pinCode;
  final String? businessName;
  final String? businessRepresentative;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.pinCode,
    this.businessName,
    this.businessRepresentative,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      pinCode: json['pincode'] ?? json['pinCode'] ?? '',
      businessName: json['businessName'] ?? '',
      businessRepresentative: json['businessRepresentative'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'pinCode': pinCode,
        'businessName': businessName,
        'businessRepresentative': businessRepresentative,
      };
  

  
}
