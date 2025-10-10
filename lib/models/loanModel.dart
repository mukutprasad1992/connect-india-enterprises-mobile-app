class LoanModel {
  final String? id;

  // Personal details
  String? panNumber;
  String? aadharNumber;
  String? motherName;
  String? maritalStatus;
  String? currentAddress;

  // Contact details

  int? yearsOfCity;
  String? alternateNo;
  String? landmark;

  // employmentDetails

  String? designation;
  int? companyExp;
  int? totalWorkExp;
  String? officeAddress;
  String? officeMobile;

  //referenceDetails

  String? ref1Name;
  String? ref1Mobile;
  String? ref1Address;

  String? ref2Name;
  String? ref2Mobile;
  String? ref2Address;

  //documents

  dynamic photoFileKey;
  dynamic panCardFileKey;
  dynamic aadharCardFileKey;
  dynamic salarySlipsFileKey;
  dynamic bankStatementFileKey;

  // review
  bool? submit;
  String? activeSteps;
  String? loanType;
  String? status;

  LoanModel({
    this.id,
    this.motherName,
    this.landmark,
    this.currentAddress,
    this.yearsOfCity,
    this.alternateNo,
    this.maritalStatus,
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
    this.panNumber,
    this.aadharNumber,
    this.photoFileKey,
    this.panCardFileKey,
    this.aadharCardFileKey,
    this.salarySlipsFileKey,
    this.bankStatementFileKey,
    this.submit,
    this.activeSteps,
    this.loanType,
    this.status,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id']?.toString(),
      motherName: json['motherName']?.toString(),
      landmark: json['landmark']?.toString(),
      currentAddress: json['currentAddress']?.toString(),
      yearsOfCity: json['yearsOfCity'] != null
          ? int.tryParse(json['yearsOfCity'].toString())
          : null,
      alternateNo: json['alternateNo']?.toString(),
      maritalStatus: json['maritalStatus']?.toString(),
      designation: json['designation']?.toString(),
      companyExp: json['companyExp'] != null
          ? int.tryParse(json['companyExp'].toString())
          : null,
      totalWorkExp: json['totalWorkExp'] != null
          ? int.tryParse(json['totalWorkExp'].toString())
          : null,
      officeAddress: json['officeAddress']?.toString(),
      officeMobile: json['officeMobile']?.toString(),
      ref1Name: json['ref1Name']?.toString(),
      ref1Mobile: json['ref1Mobile']?.toString(),
      ref1Address: json['ref1Address']?.toString(),
      ref2Name: json['ref2Name']?.toString(),
      ref2Mobile: json['ref2Mobile']?.toString(),
      ref2Address: json['ref2Address']?.toString(),
      panNumber: json['panNumber']?.toString(),
      aadharNumber: json['aadharNumber']?.toString(),
      photoFileKey: json['photoFileKey']?.toString(),
      panCardFileKey: json['panCardFileKey']?.toString(),
      aadharCardFileKey: json['aadharCardFileKey']?.toString(),
      salarySlipsFileKey: json['salarySlipsFileKey']?.toString(),
      bankStatementFileKey: json['bankStatementFileKey']?.toString(),
      submit: json['submit'] != null
          ? (json['submit'] is bool
              ? json['submit']
              : json['submit'].toString() == '1')
          : false,
      activeSteps: json['activeSteps']?.toString(),
      loanType: json['loanType']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'motherName': motherName,
      'landmark': landmark,
      'currentAddress': currentAddress,
      'yearsOfCity': yearsOfCity,
      'alternateNo': alternateNo,
      'maritalStatus': maritalStatus,
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
      'panNumber': panNumber,
      'aadharNumber': aadharNumber,
      'photoFileKey': photoFileKey,
      'panCardFileKey': panCardFileKey,
      'aadharCardFileKey': aadharCardFileKey,
      'salarySlipsFileKey': salarySlipsFileKey,
      'bankStatementFileKey': bankStatementFileKey,
      'submit': submit,
      'activeSteps': activeSteps,
      'loanType': loanType,
      'status': status,
    };
  }
}
