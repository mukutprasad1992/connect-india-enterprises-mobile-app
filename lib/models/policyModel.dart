// import 'package:myapp/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';
// import 'models/citymodel.dart';

// class PolicyModel {
//   final String id;
//   final String investmentType;

//   // Basic Details
//   final String aadharNumber;
//   final String panNumber;

//   // Personal Details
//   final String motherName;
//   final String heightCM;
//   final String weightKG;
//   final String smoker;
//   final String alcohol;
//   final Map<String, dynamic> placeOfBirth;
//   //final PlaceOfBirth placeOfBirth;
//   final String occupation;
//   final String income;

//   // Nominee Details
//   final String nomineeName;
//   final String nomineeDOB;
//   final String? nomineeRelation;

//   // Documents
//   final String aadharCardFileKey;
//   final String panCardFileKey;
//   final String bankProofFileKey;
//   final String? salarySlipsFileKey;
//   final String? itrDocumentsFileKey;

//   // Review / Status
//   final String status;
//   final int submit;

//   PolicyModel({
//     required this.id,
//     required this.investmentType,

//     // Basic
//     required this.aadharNumber,
//     required this.panNumber,

//     // Personal
//     required this.motherName,
//     required this.heightCM,
//     required this.weightKG,
//     required this.smoker,
//     required this.alcohol,
//     required this.placeOfBirth,
//     required this.occupation,
//     required this.income,

//     // Nominee
//     required this.nomineeName,
//     required this.nomineeDOB,
//     this.nomineeRelation,

//     // Docs
//     required this.aadharCardFileKey,
//     required this.panCardFileKey,
//     required this.bankProofFileKey,
//     this.salarySlipsFileKey,
//     this.itrDocumentsFileKey,

//     // Status
//     required this.submit,
//     this.status = "Pending",
//   });

//   factory PolicyModel.fromJson(Map<String, dynamic> json) {
//     final rawStatus = json['status']?.toString() ?? "Pending";
//     const allowedStatuses = ["Pending", "In Progress", "Approved", "Rejected"];

//     return PolicyModel(
//       id: json['id']?.toString() ?? '',
//       investmentType: json['serviceSubTypeName'] ?? '',
//       aadharNumber: json['aadharNumber'] ?? '',
//       panNumber: json['panNumber'] ?? '',
//       motherName: json['motherName'] ?? '',
//       heightCM: json['heightCM'] ?? '',
//       weightKG: json['weightKG'] ?? '',
//       smoker: json['smoker'] ?? '',
//       alcohol: json['alcohol'] ?? '',

//       // placeOfBirth: json['placeOfBirth'] != null
//       //     ? PlaceOfBirth.fromJson(json['placeOfBirth'])
//       //     : PlaceOfBirth(city: '', state: ''),

//       placeOfBirth: json['placeOfBirth'] is Map<String, dynamic>? json['placeOfBirth']: {},

//       occupation: json['occupation'] ?? '',
//       income: json['income']?.toString() ?? '',
//       nomineeName: json['nomineeName'] ?? '',
//       nomineeDOB: json['nomineeDOB'] ?? '',
//       nomineeRelation: json['nomineeRelation'],
//       aadharCardFileKey: json['aadhaarCardFileKey'] ?? '',
//       panCardFileKey: json['panCardFileKey'] ?? '',
//       bankProofFileKey: json['bankProofFileKey'] ?? '',
//       salarySlipsFileKey: json['salarySlipsFileKey'],
//       itrDocumentsFileKey: json['itrDocumentsFileKey'],
//       submit: json['submit'] is int
//           ? json['submit']
//           : int.tryParse(json['submit']?.toString() ?? "0") ?? 0,
//       status: allowedStatuses.contains(rawStatus) ? rawStatus : "Pending",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'investmentType': investmentType,
//       'aadharNumber': aadharNumber,
//       'panNumber': panNumber,
//       'motherName': motherName,
//       'heightCM': heightCM,
//       'weightKG': weightKG,
//       'smoker': smoker,
//       'alcohol': alcohol,
//       'placeOfBirth': placeOfBirth,
//       'occupation': occupation,
//       'income': income,
//       'nomineeName': nomineeName,
//       'nomineeDOB': nomineeDOB,
//       'nomineeRelation': nomineeRelation,
//       'aadhaarCardFileKey': aadharCardFileKey,
//       'panCardFileKey': panCardFileKey,
//       'bankProofFileKey': bankProofFileKey,
//       'salarySlipsFileKey': salarySlipsFileKey,
//       'itrDocumentsFileKey': itrDocumentsFileKey,
//       'submit': submit,
//       'status': status,
//     };
//   }
// }
