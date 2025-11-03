class VoucherController {
  static String? validatvendor(String? v) {
    if (v == null || v.isEmpty) return "Vendor ID is required";
    return null;
  }

  static String? validatecustomerName(String? v) {
    if (v == null || v.isEmpty) return "Customer ID is required";
    return null;
  }

  static String? validateAmount(String? v) {
    if (v == null || v.trim().isEmpty) return 'Amount is required';
    if (double.tryParse(v) == null) return 'Enter a valid number';
    return null;
  }

  static String? validatevoucherCode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Voucher Code is required';
    return null;
  }

  static String? validatevalidityFrom(String? v) {
    if (v == null || v.trim().isEmpty) return 'Validity From is required';
    return null;
  }

  static String? validatevalidityTo(String? v) {
    if (v == null || v.trim().isEmpty) return 'Validity To is required';
    return null;
  }
}
