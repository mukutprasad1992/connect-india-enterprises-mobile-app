
class ProfileModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNo;
  final String? password;
  final int? roleId;
  final String? status;
  final int? createdBy;
  final String? businessName;
  final String? businessRepresentative;
  final String? address;
  final String? vendorCode;
  final int? pinCode;
  final String? profileImageURL;

  ProfileModel({
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNo,
    this.password,
    this.roleId,
    this.status,
    this.createdBy,
    this.businessName,
    this.businessRepresentative,
    this.address,
    this.vendorCode,
    this.pinCode,
    this.profileImageURL,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        mobileNo: json['mobileNo'] as String?,
        password: json['password'] as String?,
        roleId: json['roleId'] is int
            ? json['roleId'] as int
            : (json['roleId'] != null
                ? int.tryParse(json['roleId'].toString())
                : null),
        status: json['status'] as String?,
        createdBy: json['createdBy'] is int
            ? json['createdBy'] as int
            : (json['createdBy'] != null
                ? int.tryParse(json['createdBy'].toString())
                : null),
        businessName: json['businessName'] as String?,
        businessRepresentative: json['businessRepresentative'] as String?,
        address: json['address'] as String?,
        vendorCode: json['vendorCode'] as String?,
        pinCode: json['pinCode'] is int
            ? json['pinCode'] as int
            : (json['pinCode'] != null
                ? int.tryParse(json['pinCode'].toString())
                : null),
        profileImageURL: json['profileImageURL'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (email != null) 'email': email,
        if (mobileNo != null) 'mobileNo': mobileNo,
      };
}
