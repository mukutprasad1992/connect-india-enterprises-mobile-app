

class VendorController {
  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return "Email is required";
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(v)) {
      return "Invalid email";
    }
    return null;
  }

  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return "Mobile Number is required";
    if (!RegExp(r"^\d{10}$").hasMatch(v)) return "Invalid Mobile Number";
    return null;
  }

  static String? validateBuisnessName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Business Name is required';
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(v)) return 'Only letters allowed';
    return null;
  }

  static String? validateRepresentative(String? v) {
    if (v == null || v.trim().isEmpty) return 'Representative is required';
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(v)) return 'Only letters allowed';
    return null;
  }

  static String? validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) return 'Address is required';
    if (v.trim().length < 5) return 'Address must be at least 5 characters';
    return null;
  }

  static String? validateVendorCode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vendor Code is required';
    return null;
  }
}
