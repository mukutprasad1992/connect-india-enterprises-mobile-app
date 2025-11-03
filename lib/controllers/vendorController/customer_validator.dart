

class Vendor_CustomerController {
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

  static String? validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) return 'Address is required';
    if (v.trim().length < 5) return 'Address must be at least 5 characters';
    return null;
  }
  static String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 3) return 'name must be at least 3 characters';
    return null;
  }

  static String? validatePincode(String? v) {
    if (v == null || v.trim().isEmpty) return 'pincode Code is required';
    if (v.trim().length < 3) return 'name must be at least 3 characters';
    return null;
  }
}
