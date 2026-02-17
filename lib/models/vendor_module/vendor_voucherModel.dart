import 'dart:convert';

class VoucherModel {
  final int id;
  final String amount;
  final String voucherCode;
  final DateTime validityFrom;
  final DateTime validityTo;
  final int customerId;
  final int vendorId;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String customerEmail;
  final String customerPincode;
  final String vendorEmail;
  final String vendorMobileNo;
  final String? vendorBusinessName;
  final String? vendorBusinessRepresentative;
  final String vendorCode;
  final String? vendorPincode;
  final String? vendorAddress;
  final String? status;
  final String? pdfURL;

  VoucherModel({
    required this.id,
    required this.amount,
    required this.voucherCode,
    required this.validityFrom,
    required this.validityTo,
    required this.customerId,
    required this.vendorId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerPincode,
    required this.vendorEmail,
    required this.vendorMobileNo,
    this.vendorBusinessName,
    this.vendorBusinessRepresentative,
    required this.vendorCode,
    this.vendorPincode,
    this.vendorAddress,
    this.status,
    this.pdfURL,
  });


  factory VoucherModel.fromJson(Map<String, dynamic> json){
    return VoucherModel(
      id: json['id'],
      amount: json['amount'],
      voucherCode: json['voucherCode'],
      validityFrom: DateTime.parse(json['validityFrom']),
      validityTo: DateTime.parse(json['validityTo']),
      customerId: json['customerId'],
      vendorId: json['vendorId'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerPincode: json['customerPincode'],
      vendorEmail: json['vendorEmail'],
      vendorMobileNo: json['vendorMobileNo'],
      vendorBusinessName: json['vendorBusinessName'],
      vendorBusinessRepresentative: json['vendorBusinessRepresentative'],
      vendorCode: json['vendorCode'],
      vendorPincode: json['vendorPincode'],
      vendorAddress: json['vendorAddress'],
      status: json['status'],
      pdfURL: json['pdfURL'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'voucherCode': voucherCode,
      'validityFrom': validityFrom.toIso8601String(),
      'validityTo': validityTo.toIso8601String(),
      'customerId': customerId,
      'vendorId': vendorId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerPincode': customerPincode,
      'vendorEmail': vendorEmail,
      'vendorMobileNo': vendorMobileNo,
      'vendorBusinessName': vendorBusinessName,
      'vendorBusinessRepresentative': vendorBusinessRepresentative,
      'vendorCode': vendorCode,
      'vendorPincode': vendorPincode,
      'vendorAddress': vendorAddress,
      'status': status,
      'pdfURL': pdfURL,
    };
  }

  /// Helper: JSON string → Voucher
  static VoucherModel fromJsonString(String jsonString) =>
      VoucherModel.fromJson(jsonDecode(jsonString));

  /// Helper: Voucher → JSON string
  String toJsonString() => jsonEncode(toJson());
}
