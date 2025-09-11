// class InvestmentModel {
//   final int id;
//   final String email;
//   final String mobileNo;
//   final String status;

//   final String? aadharNumber;
//   final String? aadhaarCardFileKey;
//   final String? panNumber;
//   final String? panCardFileKey;
//   final String? bankProofFileKey;
//   final String? salarySlipsFileKey;
//   final String? itrDocumentsFileKey;
//   final String? placeOfBirth;
//   final String? income;
//   final String? occupation;
//   final String? nomineeId;
//   final String? nomineeMobile;
//   final String? nomineeRelation;
//   final bool? isDetailsConfirmed;

//   InvestmentModel({
//     required this.id,
//     required this.email,
//     required this.mobileNo,
//     required this.status,
//     this.aadharNumber,
//     this.aadhaarCardFileKey,
//     this.panNumber,
//     this.panCardFileKey,
//     this.bankProofFileKey,
//     this.salarySlipsFileKey,
//     this.itrDocumentsFileKey,
//     this.placeOfBirth,
//     this.income,
//     this.occupation,
//     this.nomineeId,
//     this.nomineeMobile,
//     this.nomineeRelation,
//     this.isDetailsConfirmed,
//   });

//   factory InvestmentModel.fromJson(Map<String, dynamic> json) {
//     return InvestmentModel(
//       id: json['id'] ?? 0,
//       email: json['email'] ?? '',
//       mobileNo: json['mobileNo'] ?? '',
//       status: json['status'] ?? '',
//       aadharNumber: json['aadharNumber'],
//       aadhaarCardFileKey: json['aadhaarCardFileKey'],
//       panNumber: json['panNumber'],
//       panCardFileKey: json['panCardFileKey'],
//       bankProofFileKey: json['bankProofFileKey'],
//       salarySlipsFileKey: json['salarySlipsFileKey'],
//       itrDocumentsFileKey: json['itrDocumentsFileKey'],
//       placeOfBirth: json['placeOfBirth'],
//       income: json['income'],
//       occupation: json['occupation'],
//       nomineeId: json['nomineeId'],
//       nomineeMobile: json['nomineeMobile'],
//       nomineeRelation: json['nomineeRelation'],
//       isDetailsConfirmed: json['isDetailsConfirmed'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'mobileNo': mobileNo,
//       'status': status,
//       'aadharNumber': aadharNumber,
//       'aadhaarCardFileKey': aadhaarCardFileKey,
//       'panNumber': panNumber,
//       'panCardFileKey': panCardFileKey,
//       'bankProofFileKey': bankProofFileKey,
//       'salarySlipsFileKey': salarySlipsFileKey,
//       'itrDocumentsFileKey': itrDocumentsFileKey,
//       'placeOfBirth': placeOfBirth,
//       'income': income,
//       'occupation': occupation,
//       'nomineeId': nomineeId,
//       'nomineeMobile': nomineeMobile,
//       'nomineeRelation': nomineeRelation,
//       'isDetailsConfirmed': isDetailsConfirmed,
//     };
//   }
// }
