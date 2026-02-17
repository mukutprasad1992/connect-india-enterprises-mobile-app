

class InsuranceFormController {
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

  // Place of Birth: must contain letters
  static String? validatePlace(String? v) {
    if (v == null || v.isEmpty) return " PlaceOfBirth is required";
    if (!RegExp(r"[a-zA-Z]").hasMatch(v)) return "Must contain letters";
    return null;
  }

  
}
