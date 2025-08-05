class Customer {
  final String id, name, email, phone, address, pinCode;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.pinCode,
  });

  factory Customer.fromMap(Map<String, String> map) {
    return Customer(
      id: map['ID'] ?? '',
      name: map['Name'] ?? '',
      email: map['Email'] ?? '',
      phone: map['Phone'] ?? '',
      address: map['Address'] ?? '',
      pinCode: map['Pin Code'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'ID': id,
      'Name': name,
      'Email': email,
      'Phone': phone,
      'Address': address,
      'Pin Code': pinCode,
    };
  }
}
