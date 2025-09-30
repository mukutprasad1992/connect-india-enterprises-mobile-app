class AddInvestmentController {
  static String? validateAadhar(String? v) {
    if (v == null || v.isEmpty) return "Adhar Number is required";
    // allow only 12 or 16 digits
    if (!RegExp(r"^(\d{12}|\d{16})$").hasMatch(v)) {
      return "Aadhar must be exactly 12 or 16 digits";
    }
    return null;
  }

  // PAN: 5 letters + 4 digits + 1 letter
  static String? validatePAN(String? v) {
    if (v == null || v.isEmpty) return " Pan Number is required";
    final pan = v.toUpperCase();
    if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(pan)) {
      return "Invalid PAN format. Format: ABCDE1234F";
    }
    return null;
  }

  // Email validation
  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return "Emai is required";
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v))
      return "Invalid email";
    return null;
  }

  // Phone validation: 10 digits
  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return " Mobile Number is required";
    if (!RegExp(r"^\d{10}$").hasMatch(v)) return "Invalid Mobile number";
    return null;
  }

  // Place of Birth: must contain letters
  static String? validatePlace(String? v) {
    if (v == null || v.isEmpty) return " PlaceOfBirth is required";
    if (!RegExp(r"[a-zA-Z]").hasMatch(v)) return "Must contain letters";
    return null;
  }

  // Integer fields: income, profit
  static String? validateInteger(String? v) {
    if (v == null || v.isEmpty) return "Required";
    if (!RegExp(r"^\d+$").hasMatch(v)) return "Must be a number";
    return null;
  }

  // Nominee ID: Aadhaar 12 or 16 digits OR PAN
  
  static String? validateNomineeId(String? v, {required String? idType}) {
  if (v == null || v.isEmpty) return " Adhar or Pan is required";

  v = v.trim();

  if (idType == "Aadhar") {
    // Aadhaar must be 12 or 16 digits
    if (!RegExp(r"^(\d{12}|\d{16})$").hasMatch(v)) {
      return "Invalid Aadhaar (must be 12 or 16 digits)";
    }
    return null;
  } else if (idType == "PAN") {
    // PAN: 5 letters + 4 digits + 1 letter (e.g., ABCDE1234F)
    final pan = v.toUpperCase();
    if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(pan)) {
      return "Invalid PAN format (e.g., ABCDE1234F)";
    }
    return null;
  }

  return "Please select ID Type";
}


  // Relation: only letters
  static String? validateRelation(String? v) {
    if (v == null || v.isEmpty) return " Nominee relation is required";
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(v)) return "Only letters allowed";
    return null;
  }
}
