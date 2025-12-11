class InquiryModel {
  // Common
  final String? id;
  final String? serviceId;
  final String? serviceSubTypeName;
  final String? status;
  final String? activeSteps;
  final int? submit;
  final String? email;
  final String? mobile;

  // NEW: profile / name
  final String? firstName;
  final String? profileImageKey;

  // ---------- Investment Section ----------
  final String? investmentId;
  final String? investmentType;
  final String? amount;
  final String? aadharNumber;
  final String? panNumber;
  final Map<String, dynamic>? placeOfBirth;
  final String? income;
  final String? occupation;
  final String? nomineeId;
  final String? nomineeIdType;
  final String? nomineeMobile;
  final String? nomineeRelation;

  final String? aadharCardFileKey;
  final String? panCardFileKey;
  final String? bankProofFileKey;
  final String? salarySlipsFileKey;
  final String? itrDocumentsFileKey;

  // ---------- Insurance Section ----------
  final String? insuranceId;
  final String? insuranceType;
  final String? motherName;
  final String? heightCM;
  final String? weightKG;
  final String? smoker;
  final String? alcohol;
  final String? nomineeName;
  final String? nomineeDOB;

  // ---------- Loan Section ----------
  final String? loanId;
  final String? maritalStatus;
  final String? currentAddress;
  final int? yearsOfCity;
  final String? alternateNo;
  final String? landmark;
  final String? designation;
  final int? companyExp;
  final int? totalWorkExp;
  final String? officeAddress;
  final String? officeMobile;
  final String? ref1Name;
  final String? ref1Mobile;
  final String? ref1Address;
  final String? ref2Name;
  final String? ref2Mobile;
  final String? ref2Address;
  final String? photoFileKey;
  final String? bankStatementFileKey;
  final String? loanType;

  InquiryModel({
    this.id,
    this.serviceId,
    this.serviceSubTypeName,
    this.status,
    this.activeSteps,
    this.submit,
    this.email,
    this.mobile,

    // NEW
    this.firstName,
    this.profileImageKey,

    // Investment
    this.investmentId,
    this.investmentType,
    this.amount,
    this.aadharNumber,
    this.panNumber,
    this.placeOfBirth,
    this.income,
    this.occupation,
    this.nomineeId,
    this.nomineeIdType,
    this.nomineeMobile,
    this.nomineeRelation,
    this.aadharCardFileKey,
    this.panCardFileKey,
    this.bankProofFileKey,
    this.salarySlipsFileKey,
    this.itrDocumentsFileKey,

    // Insurance
    this.insuranceId,
    this.insuranceType,
    this.motherName,
    this.heightCM,
    this.weightKG,
    this.smoker,
    this.alcohol,
    this.nomineeName,
    this.nomineeDOB,

    // Loan
    this.loanId,
    this.maritalStatus,
    this.currentAddress,
    this.yearsOfCity,
    this.alternateNo,
    this.landmark,
    this.designation,
    this.companyExp,
    this.totalWorkExp,
    this.officeAddress,
    this.officeMobile,
    this.ref1Name,
    this.ref1Mobile,
    this.ref1Address,
    this.ref2Name,
    this.ref2Mobile,
    this.ref2Address,
    this.photoFileKey,
    this.bankStatementFileKey,
    this.loanType,
  });

  // ✅ Factory for API data
  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id']?.toString(),
      serviceId: json['serviceId']?.toString(),
      serviceSubTypeName: json['serviceSubTypeName'],
      status: json['status'],
      activeSteps: json['activeSteps'],
      submit: json['submit'] is int
          ? json['submit']
          : int.tryParse(json['submit']?.toString() ?? '0'),
      email: json['email'] ?? json['userEmail'],
      mobile: json['mobile'] ?? json['mobileNo'],

      // NEW
      firstName: json['firstName']?.toString(),
      profileImageKey: json['profileImageKey']?.toString() ?? json['profileImageKey'],

      // Investment
      investmentId: json['investmentId']?.toString(),
      investmentType: json['serviceSubTypeName'],
      amount: json['amount']?.toString(),
      aadharNumber: json['aadharNumber'],
      panNumber: json['panNumber'],
      placeOfBirth: json['placeOfBirth'] is Map
          ? Map<String, dynamic>.from(json['placeOfBirth'])
          : null,
      income: json['income']?.toString(),
      occupation: json['occupation'],
      nomineeId: json['nomineeId']?.toString(),
      nomineeIdType: json['nomineeIdType'],
      nomineeMobile: json['nomineeMobile'],
      nomineeRelation: json['nomineeRelation'],
      aadharCardFileKey: json['aadharCardFileKey'],
      panCardFileKey: json['panCardFileKey'],
      bankProofFileKey: json['bankProofFileKey'],
      salarySlipsFileKey: json['salarySlipsFileKey'],
      itrDocumentsFileKey: json['itrDocumentsFileKey'],

      // Insurance
      insuranceId: json['insuranceId']?.toString(),
      insuranceType: json['serviceSubTypeName'],
      motherName: json['motherName'],
      heightCM: json['heightCM']?.toString(),
      weightKG: json['weightKG']?.toString(),
      smoker: json['smoker'],
      alcohol: json['alcohol'],
      nomineeName: json['nomineeName'],
      nomineeDOB: json['nomineeDOB'],

      // Loan
      loanId: json['loanId']?.toString(),
      maritalStatus: json['maritalStatus'],
      currentAddress: json['currentAddress'],
      yearsOfCity: json['yearsOfCity'] is int
          ? json['yearsOfCity']
          : int.tryParse(json['yearsOfCity']?.toString() ?? ''),
      alternateNo: json['alternateNo'],
      landmark: json['landmark'],
      designation: json['designation'],
      companyExp: json['companyExp'] is int
          ? json['companyExp']
          : int.tryParse(json['companyExp']?.toString() ?? ''),
      totalWorkExp: json['totalWorkExp'] is int
          ? json['totalWorkExp']
          : int.tryParse(json['totalWorkExp']?.toString() ?? ''),
      officeAddress: json['officeAddress'],
      officeMobile: json['officeMobile'],
      ref1Name: json['ref1Name'],
      ref1Mobile: json['ref1Mobile'],
      ref1Address: json['ref1Address'],
      ref2Name: json['ref2Name'],
      ref2Mobile: json['ref2Mobile'],
      ref2Address: json['ref2Address'],
      photoFileKey: json['photoFileKey'],
      bankStatementFileKey: json['bankStatementFileKey'],
      loanType: json['serviceSubTypeName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceId': serviceId,
        'serviceSubTypeName': serviceSubTypeName,
        'status': status,
        'activeSteps': activeSteps,
        'submit': submit,
        'email': email,
        'mobile': mobile,

        // NEW
        'firstName': firstName,
        'profileImageKey': profileImageKey,

        // Investment
        'investmentId': investmentId,
        'investmentType': investmentType,
        'amount': amount,
        'aadharNumber': aadharNumber,
        'panNumber': panNumber,
        'placeOfBirth': placeOfBirth,
        'income': income,
        'occupation': occupation,
        'nomineeId': nomineeId,
        'nomineeIdType': nomineeIdType,
        'nomineeMobile': nomineeMobile,
        'nomineeRelation': nomineeRelation,
        'aadharCardFileKey': aadharCardFileKey,
        'panCardFileKey': panCardFileKey,
        'bankProofFileKey': bankProofFileKey,
        'salarySlipsFileKey': salarySlipsFileKey,
        'itrDocumentsFileKey': itrDocumentsFileKey,

        // Insurance
        'insuranceId': insuranceId,
        'insuranceType': insuranceType,
        'motherName': motherName,
        'heightCM': heightCM,
        'weightKG': weightKG,
        'smoker': smoker,
        'alcohol': alcohol,
        'nomineeName': nomineeName,
        'nomineeDOB': nomineeDOB,

        // Loan
        'loanId': loanId,
        'maritalStatus': maritalStatus,
        'currentAddress': currentAddress,
        'yearsOfCity': yearsOfCity,
        'alternateNo': alternateNo,
        'landmark': landmark,
        'designation': designation,
        'companyExp': companyExp,
        'totalWorkExp': totalWorkExp,
        'officeAddress': officeAddress,
        'officeMobile': officeMobile,
        'ref1Name': ref1Name,
        'ref1Mobile': ref1Mobile,
        'ref1Address': ref1Address,
        'ref2Name': ref2Name,
        'ref2Mobile': ref2Mobile,
        'ref2Address': ref2Address,
        'photoFileKey': photoFileKey,
        'bankStatementFileKey': bankStatementFileKey,
        'loanType': loanType,
      };

  /// Convenience getter: construct full image URL from `profileImageKey` if present.
  /// NOTE: adjust `baseUrl` to match your S3 / CDN base URL if different.
  String? get profileImgUrl {
    if (profileImageKey == null || profileImageKey!.isEmpty) return null;
    const baseUrl = 'https://connect-india-upload-documents.s3.ap-south-1.amazonaws.com/';
    return baseUrl + profileImageKey!;
  }

  /// Convenience display name: prefer firstName -> email -> Guest Name
  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) return firstName!;
    if (email != null && email!.isNotEmpty) return email!;
    return 'Guest Name';
  }
}


// class InquiryModel {
//   // Common
//   final String? id;
//   final String? serviceId;
//   final String? serviceSubTypeName;
//   final String? status;
//   final String? activeSteps;
//   final int? submit;
//   final String? email;
//   final String? mobile;

//   // ---------- Investment Section ----------
//   final String? investmentId;
//   final String? investmentType;
//   final String? amount;
//   final String? aadharNumber;
//   final String? panNumber;
//   final Map<String, dynamic>? placeOfBirth;
//   final String? income;
//   final String? occupation;
//   final String? nomineeId;
//   final String? nomineeIdType;
//   final String? nomineeMobile;
//   final String? nomineeRelation;

//   final String? aadharCardFileKey;
//   final String? panCardFileKey;
//   final String? bankProofFileKey;
//   final String? salarySlipsFileKey;
//   final String? itrDocumentsFileKey;

//   // ---------- Insurance Section ----------
//   final String? insuranceId;
//   final String? insuranceType;
//   final String? motherName;
//   final String? heightCM;
//   final String? weightKG;
//   final String? smoker;
//   final String? alcohol;
//   final String? nomineeName;
//   final String? nomineeDOB;

//   // ---------- Loan Section ----------
//   final String? loanId;
//   final String? maritalStatus;
//   final String? currentAddress;
//   final int? yearsOfCity;
//   final String? alternateNo;
//   final String? landmark;
//   final String? designation;
//   final int? companyExp;
//   final int? totalWorkExp;
//   final String? officeAddress;
//   final String? officeMobile;
//   final String? ref1Name;
//   final String? ref1Mobile;
//   final String? ref1Address;
//   final String? ref2Name;
//   final String? ref2Mobile;
//   final String? ref2Address;
//   final String? photoFileKey;
//   final String? bankStatementFileKey;
//   final String? loanType;

//   InquiryModel({
//     this.id,
//     this.serviceId,
//     this.serviceSubTypeName,
//     this.status,
//     this.activeSteps,
//     this.submit,
//     this.email,
//     this.mobile,

//     // Investment
//     this.investmentId,
//     this.investmentType,
//     this.amount,
//     this.aadharNumber,
//     this.panNumber,
//     this.placeOfBirth,
//     this.income,
//     this.occupation,
//     this.nomineeId,
//     this.nomineeIdType,
//     this.nomineeMobile,
//     this.nomineeRelation,
//     this.aadharCardFileKey,
//     this.panCardFileKey,
//     this.bankProofFileKey,
//     this.salarySlipsFileKey,
//     this.itrDocumentsFileKey,

//     // Insurance
//     this.insuranceId,
//     this.insuranceType,
//     this.motherName,
//     this.heightCM,
//     this.weightKG,
//     this.smoker,
//     this.alcohol,
//     this.nomineeName,
//     this.nomineeDOB,

//     // Loan
//     this.loanId,
//     this.maritalStatus,
//     this.currentAddress,
//     this.yearsOfCity,
//     this.alternateNo,
//     this.landmark,
//     this.designation,
//     this.companyExp,
//     this.totalWorkExp,
//     this.officeAddress,
//     this.officeMobile,
//     this.ref1Name,
//     this.ref1Mobile,
//     this.ref1Address,
//     this.ref2Name,
//     this.ref2Mobile,
//     this.ref2Address,
//     this.photoFileKey,
//     this.bankStatementFileKey,
//     this.loanType,
//   });

//   // ✅ Factory for API data
//   factory InquiryModel.fromJson(Map<String, dynamic> json) {
//     return InquiryModel(
//       id: json['id']?.toString(),
//       serviceId: json['serviceId']?.toString(),
//       serviceSubTypeName: json['serviceSubTypeName'],
//       status: json['status'],
//       activeSteps: json['activeSteps'],
//       submit: json['submit'] is int
//           ? json['submit']
//           : int.tryParse(json['submit']?.toString() ?? '0'),
//       email: json['email'] ?? json['userEmail'],
//       mobile: json['mobile'] ?? json['mobileNo'],

//       // Investment
//       investmentId: json['investmentId']?.toString(),
//       investmentType: json['serviceSubTypeName'],
//       amount: json['amount']?.toString(),
//       aadharNumber: json['aadharNumber'],
//       panNumber: json['panNumber'],
//       placeOfBirth: json['placeOfBirth'] is Map
//           ? Map<String, dynamic>.from(json['placeOfBirth'])
//           : null,
//       income: json['income']?.toString(),
//       occupation: json['occupation'],
//       nomineeId: json['nomineeId']?.toString(),
//       nomineeIdType: json['nomineeIdType'],
//       nomineeMobile: json['nomineeMobile'],
//       nomineeRelation: json['nomineeRelation'],
//       aadharCardFileKey: json['aadharCardFileKey'],
//       panCardFileKey: json['panCardFileKey'],
//       bankProofFileKey: json['bankProofFileKey'],
//       salarySlipsFileKey: json['salarySlipsFileKey'],
//       itrDocumentsFileKey: json['itrDocumentsFileKey'],

//       // Insurance
//       insuranceId: json['insuranceId']?.toString(),
//       insuranceType: json['serviceSubTypeName'],
//       motherName: json['motherName'],
//       heightCM: json['heightCM']?.toString(),
//       weightKG: json['weightKG']?.toString(),
//       smoker: json['smoker'],
//       alcohol: json['alcohol'],
//       nomineeName: json['nomineeName'],
//       nomineeDOB: json['nomineeDOB'],

//       // Loan
//       loanId: json['loanId']?.toString(),
//       maritalStatus: json['maritalStatus'],
//       currentAddress: json['currentAddress'],
//       yearsOfCity: json['yearsOfCity'] is int
//           ? json['yearsOfCity']
//           : int.tryParse(json['yearsOfCity']?.toString() ?? ''),
//       alternateNo: json['alternateNo'],
//       landmark: json['landmark'],
//       designation: json['designation'],
//       companyExp: json['companyExp'] is int
//           ? json['companyExp']
//           : int.tryParse(json['companyExp']?.toString() ?? ''),
//       totalWorkExp: json['totalWorkExp'] is int
//           ? json['totalWorkExp']
//           : int.tryParse(json['totalWorkExp']?.toString() ?? ''),
//       officeAddress: json['officeAddress'],
//       officeMobile: json['officeMobile'],
//       ref1Name: json['ref1Name'],
//       ref1Mobile: json['ref1Mobile'],
//       ref1Address: json['ref1Address'],
//       ref2Name: json['ref2Name'],
//       ref2Mobile: json['ref2Mobile'],
//       ref2Address: json['ref2Address'],
//       photoFileKey: json['photoFileKey'],
//       bankStatementFileKey: json['bankStatementFileKey'],
//       loanType: json['serviceSubTypeName'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'serviceId': serviceId,
//         'serviceSubTypeName': serviceSubTypeName,
//         'status': status,
//         'activeSteps': activeSteps,
//         'submit': submit,
//         'email': email,
//         'mobile': mobile,

//         // Investment
//         'investmentId': investmentId,
//         'investmentType': investmentType,
//         'amount': amount,
//         'aadharNumber': aadharNumber,
//         'panNumber': panNumber,
//         'placeOfBirth': placeOfBirth,
//         'income': income,
//         'occupation': occupation,
//         'nomineeId': nomineeId,
//         'nomineeIdType': nomineeIdType,
//         'nomineeMobile': nomineeMobile,
//         'nomineeRelation': nomineeRelation,
//         'aadharCardFileKey': aadharCardFileKey,
//         'panCardFileKey': panCardFileKey,
//         'bankProofFileKey': bankProofFileKey,
//         'salarySlipsFileKey': salarySlipsFileKey,
//         'itrDocumentsFileKey': itrDocumentsFileKey,

//         // Insurance
//         'insuranceId': insuranceId,
//         'insuranceType': insuranceType,
//         'motherName': motherName,
//         'heightCM': heightCM,
//         'weightKG': weightKG,
//         'smoker': smoker,
//         'alcohol': alcohol,
//         'nomineeName': nomineeName,
//         'nomineeDOB': nomineeDOB,

//         // Loan
//         'loanId': loanId,
//         'maritalStatus': maritalStatus,
//         'currentAddress': currentAddress,
//         'yearsOfCity': yearsOfCity,
//         'alternateNo': alternateNo,
//         'landmark': landmark,
//         'designation': designation,
//         'companyExp': companyExp,
//         'totalWorkExp': totalWorkExp,
//         'officeAddress': officeAddress,
//         'officeMobile': officeMobile,
//         'ref1Name': ref1Name,
//         'ref1Mobile': ref1Mobile,
//         'ref1Address': ref1Address,
//         'ref2Name': ref2Name,
//         'ref2Mobile': ref2Mobile,
//         'ref2Address': ref2Address,
//         'photoFileKey': photoFileKey,
//         'bankStatementFileKey': bankStatementFileKey,
//         'loanType': loanType,
//       };
// }

