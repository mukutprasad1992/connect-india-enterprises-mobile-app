
class InsuranceModel {
  final String id;
  final String insuranceType;

  // Basic Details
  final String aadharNumber;
  final String panNumber;

  // Personal Details
  final Map<String, dynamic> placeOfBirth;
  final String motherName;
  final String heightCM;
  final String weightKG;
  final String smoker;
  final String alcohol;
  final String income;
  final String occupation;

  // Nominee Details
  final String nomineeName;
  final String nomineeDOB;
  final String? nomineeRelation;

  // Documents
  final String aadharCardFileKey;
  final String panCardFileKey;
  final String bankProofFileKey;
  final String? salarySlipsFileKey;
  final String? itrDocumentsFileKey;

  // Review / Status
  final String status;
  final int submit;

  InsuranceModel({
    required this.id,
    required this.insuranceType,

    // Basic
    required this.aadharNumber,
    required this.panNumber,

    // Personal
    required this.motherName,
    required this.heightCM,
    required this.weightKG,
    required this.smoker,
    required this.alcohol,
    required this.placeOfBirth,
    required this.occupation,
    required this.income,

    // Nominee
    required this.nomineeName,
    required this.nomineeDOB,
    this.nomineeRelation,

    // Docs
    required this.aadharCardFileKey,
    required this.panCardFileKey,
    required this.bankProofFileKey,
    this.salarySlipsFileKey,
    this.itrDocumentsFileKey,

    // Status
    required this.submit,
    this.status = "Pending",
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString() ?? "Pending";
    const allowedStatuses = ["Pending", "In Progress", "Approved", "Rejected"];

    return InsuranceModel(
      id: json['id']?.toString() ?? '',
      insuranceType: json['serviceSubTypeName'] ?? '',
      aadharNumber: json['aadharNumber'] ?? '',
      panNumber: json['panNumber'] ?? '',
      motherName: json['motherName'] ?? '',
      heightCM: json['heightCM']?.toString() ?? '',
      weightKG: json['weightKG']?.toString() ?? '',
      smoker: json['smoker'] ?? '',
      alcohol: json['alcohol'] ?? '',

      // placeOfBirth: json['placeOfBirth'] != null
      //     ? PlaceOfBirth.fromJson(json['placeOfBirth'])
      //     : PlaceOfBirth(city: '', state: ''),

      placeOfBirth: json['placeOfBirth'] is Map<String, dynamic>
          ? json['placeOfBirth']
          : {},

      occupation: json['occupation'] ?? '',
      income: json['income']?.toString() ?? '',
      nomineeName: json['nomineeName'] ?? '',
      nomineeDOB: json['nomineeDOB'] ?? '',
      nomineeRelation: json['nomineeRelation'],
      aadharCardFileKey: json['aadharCardFileKey'] ?? '',
      panCardFileKey: json['panCardFileKey'] ?? '',
      bankProofFileKey: json['bankProofFileKey'] ?? '',
      salarySlipsFileKey: json['salarySlipsFileKey'],
      itrDocumentsFileKey: json['itrDocumentsFileKey'],
      submit: json['submit'] is int
          ? json['submit']
          : int.tryParse(json['submit']?.toString() ?? "0") ?? 0,
      status: allowedStatuses.contains(rawStatus) ? rawStatus : "Pending",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'insuranceType': insuranceType,
      'aadharNumber': aadharNumber,
      'panNumber': panNumber,
      'motherName': motherName,
      'heightCM': heightCM,
      'weightKG': weightKG,
      'smoker': smoker,
      'alcohol': alcohol,
      'placeOfBirth': placeOfBirth,
      'occupation': occupation,
      'income': income,
      'nomineeName': nomineeName,
      'nomineeDOB': nomineeDOB,
      'nomineeRelation': nomineeRelation,
      'aadharCardFileKey': aadharCardFileKey,
      'panCardFileKey': panCardFileKey,
      'bankProofFileKey': bankProofFileKey,
      'salarySlipsFileKey': salarySlipsFileKey,
      'itrDocumentsFileKey': itrDocumentsFileKey,
      'submit': submit,
      'status': status,
    };
  }
}
