class CreateVoucherModel {
  final int id;
  final int vendorId;
  final int customerId;
  final double amount;
  final String voucherCode;
  final String? validityFrom;
  final String? validityTo;
  final String? status;

  CreateVoucherModel({
    required this.id,
    required this.vendorId,
    required this.customerId,
    required this.amount,
    required this.voucherCode,
    this.validityFrom,
    this.validityTo,
    this.status
  });

  factory CreateVoucherModel.fromJson(Map<String, dynamic> json) {
    return CreateVoucherModel(
      id: json['id'] ?? 0,
      vendorId: json['vendorId'] ?? 0,
      customerId: json['customerId'] ?? 0,
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0),
      voucherCode: json['voucherCode'] ?? '',
      validityFrom: json['validityFrom'],
      validityTo: json['validityTo'],
      //redeemed: json['Redeemed'] ?? false,
      status: json['status'] ?? 'enable',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'customerId': customerId,
      'amount': amount,
      'voucherCode': voucherCode,
      'validityFrom': validityFrom,
      'validityTo': validityTo,
      //'Redeemed': redeemed,
      'status': status,
    };
  }
}
