class VoucherModel {
  final String vendor;
  final String customer;
  final String amount;
  final String code;
  final String validityFrom;
  final String validityTo;
  final bool redeemed;
  final String status;

  VoucherModel({
    required this.vendor,
    required this.customer,
    required this.amount,
    required this.code,
    required this.validityFrom,
    required this.validityTo,
    this.redeemed = false,
    this.status = 'Active',
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      vendor: json['vendor'] ?? '',
      customer: json['customer'] ?? '',
      amount: json['amount'] ?? '',
      code: json['code'] ?? '',
      validityFrom: json['validityFrom'] ?? '',
      validityTo: json['validityTo'] ?? '',
      redeemed: json['redeemed'] ?? false,
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor': vendor,
      'customer': customer,
      'amount': amount,
      'code': code,
      'validityFrom': validityFrom,
      'validityTo': validityTo,
      'redeemed': redeemed,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'VoucherModel(vendor: $vendor, customer: $customer, amount: $amount, code: $code, '
        'validityFrom: $validityFrom, validityTo: $validityTo, redeemed: $redeemed, status: $status)';
  }
}
