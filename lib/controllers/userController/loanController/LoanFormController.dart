


class AddLoanController {
  static String? validateAadhar(String? v) {
    if (v == null || v.isEmpty) return "Aadhar Number is required";
    // allow only 12 or 16 digits
    if (!RegExp(r"^(\d{12}|\d{16})$").hasMatch(v)) {
      return "Aadhar must be exactly 12 or 16 digits";
    }
    return null;
  }

  // PAN: 5 letters + 4 digits + 1 letter
  static String? validatePAN(String? v) {
    if (v == null || v.isEmpty) return "PAN Number is required";
    final pan = v.toUpperCase();
    if (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(pan)) {
      return "Invalid PAN format. Format: ABCDE1234F";
    }
    return null;
  }

  // ✅ Mother’s Name validation
  static String? validateMotherName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return "Mother’s name is required";
    }
    if (v.trim().length < 3) {
      return "Name must be at least 3 characters";
    }
    if (!RegExp(r"^[A-Za-z\s.]+$").hasMatch(v.trim())) {
      return "Name must contain only letters";
    }
    return null;
  }

  // ✅ Marital Status validation
  static String? validateMaritalStatus(String? v) {
    if (v == null || v.trim().isEmpty) {
      return "Marital status is required";
    }
    // Allow only specific valid values
    final validStatuses = [
      "Single",
      "Married",
      "Divorced",
      "Widowed",
      "Separated"
    ];
    if (!validStatuses
        .map((e) => e.toLowerCase())
        .contains(v.trim().toLowerCase())) {
      return "Please select a valid marital status";
    }
    return null;
  }

  // ✅ Current Address validation
  static String? validateCurrentAddress(String? v) {
    if (v == null || v.trim().isEmpty) {
      return "Current address is required";
    }
    if (v.trim().length < 5) {
      return "Address must be at least 5 characters";
    }
    return null;
  }

  //------------------------ Contact details ---------------------------------------//
  

  // ✅ Alternate Phone Validation
  static String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return "Alternate number is required";
    if (!RegExp(r"^[6-9]\d{9}$").hasMatch(v.trim())) {
      return "Enter a valid 10-digit mobile number";
    }
    return null;
  }

  // ✅ Years in Current City Validation
  static String? validateYearsInCity(String? v) {
    if (v == null || v.trim().isEmpty) return "Years in city is required";
    final num? years = num.tryParse(v);
    if (years == null) return "Enter a valid number";
    if (years < 0 || years > 100) return "Enter a valid range (0–100)";
    return null;
  }

  // ✅ Landmark Validation
  static String? validateLandmark(String? v) {
    if (v == null || v.trim().isEmpty) return "Landmark is required";
    if (v.trim().length < 5) {
      return "Landmark must be at least 5 characters";
    }
    return null;
  }

  // ------------------- Employment Details validation----------------------

  static String? validateDesignation(String? v) {
    if (v == null || v.trim().isEmpty) return "Designation is required";
    if (v.trim().length < 2) return "Designation must be at least 2 characters";
    return null;
  }

  static String? validateCompanyExp(String? v) {
    if (v == null || v.trim().isEmpty) return "Company experience is required";
    final num? exp = num.tryParse(v.trim());
    if (exp == null) return "Enter a valid number";
    if (exp < 0 || exp > 60) return "Enter a valid range (0–60)";
    return null;
  }

  static String? validateTotalWorkExp(String? v) {
    if (v == null || v.trim().isEmpty) return "Total work experience is required";
    final num? exp = num.tryParse(v.trim());
    if (exp == null) return "Enter a valid number";
    if (exp < 0 || exp > 80) return "Enter a valid range (0–80)";
    return null;
  }

  static String? validateOfficeAddress(String? v) {
    if (v == null || v.trim().isEmpty) return "Office address is required";
    if (v.trim().length < 5) return "Address must be at least 5 characters";
    return null;
  }

  static String? validatemobile(String? v) {
    if (v == null || v.trim().isEmpty) return "Mobile number is required";
    if (!RegExp(r"^[6-9]\d{9}$").hasMatch(v.trim())) {
      return "Enter a valid 10-digit mobile number";
    }
    return null;
  }

}
