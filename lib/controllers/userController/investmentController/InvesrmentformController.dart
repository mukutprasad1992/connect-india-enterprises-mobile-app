class AddInvestmentController {
  // Aadhar: exactly 12 digits
  static String? validateAadhar(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^\d{12}$").hasMatch(v)) return "Aadhar must be 12 digits";
    return null;
  }

  // PAN: 5 letters + 4 digits + 1 letter
  static String? validatePAN(String? v) {
    if (v == null || v.isEmpty) return "Required";
    final pan = v.toUpperCase();
    if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(pan)) {
      return "Invalid PAN format. Format: ABCDE1234F";
    }
    return null;
  }

  // Email validation
  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v))
      return "Invalid email";
    return null;
  }

  // Phone validation: 10 digits
  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^\d{10}$").hasMatch(v)) return "Invalid phone number";
    return null;
  }

  // Place of Birth: must contain letters
  static String? validatePlace(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"[a-zA-Z]").hasMatch(v)) return "Must contain letters";
    return null;
  }

  // Integer fields: income, profit
  static String? validateInteger(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^\d+$").hasMatch(v)) return "Must be a number";
    return null;
  }

  // Nominee ID: Aadhaar 12 digits OR PAN
  static String? validateNomineeId(String? v, {required String? idType}) {
    if (v == null || v.isEmpty) return "Required";
    v = v.trim();

    if (idType == "Aadhar") {
      // Validate Aadhaar: exactly 12 digits
      if (!RegExp(r"^\d{12}$").hasMatch(v)) {
        return "Aadhar must be 12 digits";
      }
      return null;
    } else if (idType == "PAN") {
      // Validate PAN: 5 letters + 4 digits + 1 letter
      final pan = v.toUpperCase();
      if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(pan)) {
        return "Invalid PAN format. Format: ABCDE1234F";
      }
      return null;
    }

    return "Please select ID Type";
  }

  // Relation: only letters
  static String? validateRelation(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(v)) return "Only letters allowed";
    return null;
  }
}
