class InquiryModel {
  final String id;
  final String serviceId;
  final String email;
  final String mobile;
  final String investmentType; 
  final String amount; 
  final String aadharNumber;
  final String aadhaarCardFileKey;
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

  final int submit;
  String status;

  InquiryModel({
    required this.id,
    required this.serviceId,
    required this.email,
    required this.mobile,
    required this.investmentType,
    required this.amount,
    required this.aadharNumber,
    required this.aadhaarCardFileKey,
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

  /// ✅ Factory: Convert API JSON → Model
  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? "Pending";
    const allowedStatuses = ["Pending", "In Progress", "Approved", "Rejected"];

    return InquiryModel(
      id: json['id']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? '',
      email: json['email'] ?? json['userEmail'] ?? '',
      mobile: json['mobile'] ?? json['userMobile'] ?? '',
      investmentType: json['serviceSubTypeName'] ?? '',
      amount: json['income']?.toString() ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      aadhaarCardFileKey: json['aadharCardFileKey'] ?? '',
      panNumber: json['panNumber'] ?? '',
      panCardFileKey: json['panCardFileKey'] ?? '',
      bankProofFileKey: json['bankProofFileKey'] ?? '',
      salarySlipsFileKey: json['salarySlipsFileKey'],
      itrDocumentsFileKey: json['itrDocumentsFileKey'],
      placeOfBirth: json['placeOfBirth'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['placeOfBirth'])
          : {},
      income: json['income']?.toString() ?? '',
      occupation: json['occupation'] ?? '',
      nomineeId: json['nomineeId']?.toString(),
      nomineeIdType: json['nomineeIdType']?.toString(),
      nomineeMobile: json['nomineeMobile'],
      nomineeRelation: json['nomineeRelation'],
      submit: json['submit'] is int
          ? json['submit'] as int
          : int.tryParse(json['submit']?.toString() ?? "0") ?? 0,
      status: allowedStatuses.contains(rawStatus) ? rawStatus : "Pending",
    );
  }

  /// ✅ Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'email': email,
      'mobile': mobile,
      'investmentType': investmentType,
      'amount': amount,
      'aadharNumber': aadharNumber,
      'aadharCardFileKey': aadhaarCardFileKey,
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

  /// ✅ CopyWith for immutability
  InquiryModel copyWith({
    String? id,
    String? serviceId,
    String? email,
    String? mobile,
    String? investmentType,
    String? amount,
    String? aadharNumber,
    String? aadhaarCardFileKey,
    String? panNumber,
    String? panCardFileKey,
    String? bankProofFileKey,
    String? salarySlipsFileKey,
    String? itrDocumentsFileKey,
    Map<String, dynamic>? placeOfBirth,
    String? income,
    String? occupation,
    String? nomineeId,
    String? nomineeIdType,
    String? nomineeMobile,
    String? nomineeRelation,
    int? submit,
    String? status,
  }) {
    return InquiryModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      investmentType: investmentType ?? this.investmentType,
      amount: amount ?? this.amount,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      aadhaarCardFileKey: aadhaarCardFileKey ?? this.aadhaarCardFileKey,
      panNumber: panNumber ?? this.panNumber,
      panCardFileKey: panCardFileKey ?? this.panCardFileKey,
      bankProofFileKey: bankProofFileKey ?? this.bankProofFileKey,
      salarySlipsFileKey: salarySlipsFileKey ?? this.salarySlipsFileKey,
      itrDocumentsFileKey: itrDocumentsFileKey ?? this.itrDocumentsFileKey,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      income: income ?? this.income,
      occupation: occupation ?? this.occupation,
      nomineeId: nomineeId ?? this.nomineeId,
      nomineeIdType: nomineeIdType ?? this.nomineeIdType,
      nomineeMobile: nomineeMobile ?? this.nomineeMobile,
      nomineeRelation: nomineeRelation ?? this.nomineeRelation,
      submit: submit ?? this.submit,
      status: status ?? this.status,
    );
  }
}
