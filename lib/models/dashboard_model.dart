class ServiceTypeData {
  final ServiceDetail investment;
  final ServiceDetail policy;
  final ServiceDetail insurance;
  final ServiceDetail loan;

  ServiceTypeData({
    required this.investment,
    required this.policy,
    required this.insurance,
    required this.loan,
  });

  factory ServiceTypeData.fromJson(Map<String, dynamic> json) {
    return ServiceTypeData(
      investment: ServiceDetail.fromJson(json['Investment'] ?? {}),
      policy: ServiceDetail.fromJson(json['Policy'] ?? {}),
      insurance: ServiceDetail.fromJson(json['Insurance'] ?? {}),
      loan: ServiceDetail.fromJson(json['Loan'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Investment': investment.toJson(),
      'Policy': policy.toJson(),
      'Insurance': insurance.toJson(),
      'Loan': loan.toJson(),
    };
  }
}

class ServiceDetail {
  final String totalServices;
  final int totalAmount;

  ServiceDetail({
    required this.totalServices,
    required this.totalAmount,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      totalServices: json['totalServices']?.toString() ?? '0',
      totalAmount: json['totalAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalServices': totalServices,
      'totalAmount': totalAmount,
    };
  }
}
