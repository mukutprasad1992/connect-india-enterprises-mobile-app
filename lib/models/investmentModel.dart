class InvestmentModel {
  final String id;
  final String email;
  final String mobile;
  final String investmentType;
  final String amount;
  final String aadharNumber;
  final String aadharCardFileKey;
  final String panNumber;
  final String panCardFileKey;
  final String bankProofFileKey;
  final String? salarySlipsFileKey;
  final String? itrDocumentsFileKey;
  final Map<String, dynamic> placeOfBirth;
  final String income;
  final String occupation;

  final String? nomineeId;
  final String? nomineeIdType;
  final String? nomineeMobile;
  final String? nomineeRelation;

  final String status;
  final int submit;

  InvestmentModel({
    required this.id,
    required this.email,
    required this.mobile,
    required this.investmentType,
    required this.amount,
    required this.aadharNumber,
    required this.aadharCardFileKey,
    required this.panNumber,
    required this.panCardFileKey,
    required this.bankProofFileKey,
    this.salarySlipsFileKey,
    this.itrDocumentsFileKey,
    required this.placeOfBirth,
    required this.income,
    required this.occupation,
    this.nomineeId,
    this.nomineeIdType,
    this.nomineeMobile,
    this.nomineeRelation,
    required this.submit,
    this.status = "Pending",
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? "Pending";
    const allowedStatuses = ["Pending", "In Progress", "Approved", "Rejected"];

    return InvestmentModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      investmentType: json['serviceSubTypeName'] ?? '', 
      amount: json['amount']?.toString() ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      aadharCardFileKey: json['aadharCardFileKey'] ?? '',
      panNumber: json['panNumber'] ?? '',
      panCardFileKey: json['panCardFileKey'] ?? '',
      bankProofFileKey: json['bankProofFileKey'] ?? '',
      salarySlipsFileKey: json['salarySlipsFileKey'],
      itrDocumentsFileKey: json['itrDocumentsFileKey'],
      
      placeOfBirth: json['placeOfBirth'] is Map<String, dynamic>
          ? json['placeOfBirth']
          : {},
      income: json['income']?.toString() ?? '',
      occupation: json['occupation'] ?? '',
      nomineeId: json['nomineeId']?.toString(),
      nomineeIdType: json['nomineeIdType']?.toString(),
      nomineeMobile: json['nomineeMobile'],
      nomineeRelation: json['nomineeRelation'],
      submit: json['submit'] is int
          ? json['submit']
          : int.tryParse(json['submit']?.toString() ?? "0") ?? 0, 
      status: allowedStatuses.contains(rawStatus) ? rawStatus : "Pending",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'investmentType': investmentType,
      'amount': amount,
      'aadharNumber': aadharNumber,
      'aadharCardFileKey': aadharCardFileKey,
      'panNumber': panNumber,
      'panCardFileKey': panCardFileKey,
      'bankProofFileKey': bankProofFileKey,
      'salarySlipsFileKey': salarySlipsFileKey,
      'itrDocumentsFileKey': itrDocumentsFileKey,
      'placeOfBirth': placeOfBirth,
      'income': income,
      'occupation': occupation,
      'nomineeId': nomineeId,
      'nomineeIdType': nomineeIdType,
      'nomineeMobile': nomineeMobile,
      'nomineeRelation': nomineeRelation,
      'submit': submit,
      'status': status,
    };
  }
}

