import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/consts/appColors.dart';
import 'package:flutter/services.dart';

class VoucherEditgeneratePage extends StatefulWidget {
  final Map<String, dynamic>? voucher;

  const VoucherEditgeneratePage({super.key, required this.voucher});

  @override
  State<VoucherEditgeneratePage> createState() =>
      _VoucherEditgeneratePageState();
}

class _VoucherEditgeneratePageState extends State<VoucherEditgeneratePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController vendorController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController voucherCodeController = TextEditingController();
  final TextEditingController _validityFromController = TextEditingController();
  final TextEditingController _validityToController = TextEditingController();

  DateTime? validityFrom;
  DateTime? validityTo;

  @override
  @override
  void initState() {
    super.initState();

    // If voucherData was passed in, initialize form fields
    final data = widget.voucher;
    if (data != null) {
      vendorController.text = data['vendor'] ?? '';
      customerNameController.text = data['customer'] ?? '';
      amountController.text = data['amount'] ?? '';
      voucherCodeController.text = data['code'] ?? '';
      _validityFromController.text = data['validityFrom'] ?? '';
      _validityToController.text = data['validityTo'] ?? '';

      // Optional: Set actual DateTime objects
      try {
        final fromParts = (data['validityFrom'] ?? '').split('/');
        if (fromParts.length == 3) {
          validityFrom = DateTime(
            int.parse(fromParts[2]),
            int.parse(fromParts[1]),
            int.parse(fromParts[0]),
          );
        }
        final toParts = (data['validityTo'] ?? '').split('/');
        if (toParts.length == 3) {
          validityTo = DateTime(
            int.parse(toParts[2]),
            int.parse(toParts[1]),
            int.parse(toParts[0]),
          );
        }
      } catch (_) {
        // Invalid date format fallback
      }
    }
  }

  @override
  void dispose() {
    vendorController.dispose();
    customerNameController.dispose();
    amountController.dispose();
    voucherCodeController.dispose();
    _validityFromController.dispose();
    _validityToController.dispose();
    super.dispose();
  }


  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          validityFrom = picked;
          _validityFromController.text = _formatDate(picked);
        } else {
          validityTo = picked;
          _validityToController.text = _formatDate(picked);
        }
      });
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 18),
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14),
      filled: true,
      isDense: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        validityFrom != null &&
        validityTo != null) {
      final updatedVoucher = {
        'Vendor Name': vendorController.text.trim(),
        'Customer Name': customerNameController.text.trim(),
        'Amount': amountController.text.trim(),
        'Voucher Code': voucherCodeController.text.trim(),
        'Validity From': _formatDate(validityFrom!),
        'Validity To': _formatDate(validityTo!),
        'Status': widget.voucher?['Status'] ?? 'Active',
        'Redeemed': widget.voucher?['Redeemed'] ?? 'false',
      };
      _showSuccess('Voucher Updated Successfully!');
      Navigator.pop(context, updatedVoucher);
    } else {
      _showError('Please fill all required fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > maxWidth ? maxWidth : screenWidth * 0.92;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text("Edit Voucher", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            width: formWidth,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Vendor Name
                  TextFormField(
                    controller: vendorController,
                    decoration: _inputDecoration('Vendor Name', Icons.store),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                  ),
                  const SizedBox(height: 18),

                  // Customer Name
                  TextFormField(
                    controller: customerNameController,
                    decoration: _inputDecoration('Customer Name', Icons.person),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                  ),
                  const SizedBox(height: 18),

                  // Amount
                  TextFormField(
                    controller: amountController,
                    decoration: _inputDecoration('Amount', Icons.attach_money),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(10),   // Max 10 digits
                    ],
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      if (!RegExp(r'^[0-9]{1,10}$').hasMatch(value)) {
                        return 'Enter up to 10 digit number only';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Voucher Code
                  TextFormField(
                    controller: voucherCodeController,
                    decoration: _inputDecoration('Voucher Code', Icons.qr_code),
                    enabled: false,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                  ),
                  const SizedBox(height: 18),

                  // Validity From
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _validityFromController,
                        decoration: _inputDecoration(
                            'Validity From', Icons.calendar_today),
                        validator: (_) =>
                            validityFrom == null ? 'Required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Validity To
                  GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _validityToController,
                        decoration: _inputDecoration(
                            'Validity To', Icons.calendar_month),
                        validator: (_) =>
                            validityTo == null ? 'Required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  _buildButtonRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(
      BuildContext context,
      String label,
      IconData icon,
      DateTime? selectedDate,
      TextEditingController controller,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: _inputDecoration(label, icon),
          validator: (_) => selectedDate == null ? 'Required' : null,
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: 130,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 50,
          width: 130,
          child: ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              "Update",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
