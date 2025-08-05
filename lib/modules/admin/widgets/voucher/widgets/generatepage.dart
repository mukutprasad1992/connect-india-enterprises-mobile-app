import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/consts/appColors.dart';

class GenerateVoucherPage extends StatefulWidget {
  const GenerateVoucherPage({super.key});

  @override
  State<GenerateVoucherPage> createState() => _GenerateVoucherPageState();
}

class _GenerateVoucherPageState extends State<GenerateVoucherPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController vendorController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController voucherCodeController = TextEditingController();
  final TextEditingController _validityFromController = TextEditingController();
  final TextEditingController _validityToController = TextEditingController();

  final FocusNode vendorFocus = FocusNode();
  final FocusNode customerFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();
  final FocusNode codeFocus = FocusNode();

  bool vendorTouched = false;
  bool customerTouched = false;
  bool amountTouched = false;
  bool codeTouched = false;
  bool _submitted = false;
  bool fromDateTouched = false;
  bool toDateTouched = false;

  DateTime? validityFrom;
  DateTime? validityTo;

  @override
  void initState() {
    super.initState();

    vendorFocus.addListener(() {
      if (vendorFocus.hasFocus) setState(() => vendorTouched = true);
    });
    customerFocus.addListener(() {
      if (customerFocus.hasFocus) setState(() => customerTouched = true);
    });
    amountFocus.addListener(() {
      if (amountFocus.hasFocus) setState(() => amountTouched = true);
    });
    codeFocus.addListener(() {
      if (codeFocus.hasFocus) setState(() => codeTouched = true);
    });
  }

  @override
  void dispose() {
    vendorController.dispose();
    customerNameController.dispose();
    amountController.dispose();
    voucherCodeController.dispose();
    _validityFromController.dispose();
    _validityToController.dispose();

    vendorFocus.dispose();
    customerFocus.dispose();
    amountFocus.dispose();
    codeFocus.dispose();

    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        validityFrom = picked;
        _validityFromController.text =
            '${picked.day}/${picked.month}/${picked.year}';

        // Reset validityTo if it's before the new from date
        if (validityTo != null &&
            validityTo!.isBefore(picked.add(const Duration(days: 1)))) {
          validityTo = null;
          _validityToController.text = '';
        }
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (validityFrom == null) {
      _showError('Please select Validity From date first');
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate:
          validityFrom!.add(const Duration(days: 1)), // Default to next day
      firstDate: validityFrom!
          .add(const Duration(days: 1)), // Can't select before from date
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        validityTo = picked;
        _validityToController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    final hasAsterisk = label.contains('*');
    final parts = hasAsterisk ? label.split('*') : [label];
    return InputDecoration(
      prefixIcon: Icon(icon, color: AppColors.background, size: 18),
      label: hasAsterisk
          ? RichText(
              text: TextSpan(text: parts[0],style: const TextStyle(fontSize: 14,color: Colors.black,),
                children: const [
                  TextSpan(text: ' *',style: TextStyle(color: Colors.red,fontSize: 14,),),
                ],
              ),
            )
          : Text(label,style: const TextStyle(fontSize: 14, color: Colors.black),),
      isDense: true,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > maxWidth ? maxWidth : screenWidth * 0.92;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Generate Voucher',
            style: TextStyle(color: Colors.white)),
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
                    color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
              ],
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _buildTextField(
                    controller: vendorController,
                    label: 'Vendor Name*',
                    icon: Icons.store,
                    validatorMsg: 'Vendor Name is required',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ],
                    focusNode: vendorFocus,
                    touched: vendorTouched,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: customerNameController,
                    label: 'Customer Name*',
                    icon: Icons.person,
                    validatorMsg: 'Customer name is required',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ],
                    focusNode: customerFocus,
                    touched: customerTouched,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: amountController,
                    label: 'Amount*',
                    icon: Icons.attach_money,
                    validatorMsg: 'Amount is required',
                    inputType: TextInputType.number,
                    focusNode: amountFocus,
                    touched: amountTouched,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: voucherCodeController,
                    label: 'Voucher Code*',
                    icon: Icons.qr_code,
                    validatorMsg: 'Voucher code is required',
                    focusNode: codeFocus,
                    touched: codeTouched,
                  ),
                  const SizedBox(height: 18),
                  _buildDateField(
                    context: context,
                    label: 'Validity From*',
                    icon: Icons.calendar_today,
                    selectedDate: validityFrom,
                    onTap: () => _selectFromDate(context),
                    errorMsg: 'Validity From is required',
                    controller: _validityFromController,
                    touched: fromDateTouched,
                  ),
                  const SizedBox(height: 18),
                  _buildDateField(
                    context: context,
                    label: 'Validity To*',
                    icon: Icons.calendar_month,
                    selectedDate: validityTo,
                    onTap: () => _selectToDate(context),
                    errorMsg: validityFrom == null
                        ? 'Select Validity From first'
                        : 'Validity To must be after Validity From',
                    controller: _validityToController,
                    touched: toDateTouched,
                    enabled: validityFrom !=
                        null, // Disable if from date not selected
                  ),
                  const SizedBox(height: 30),
                  _buildButtonRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    required FocusNode focusNode,
    required bool touched,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (!_submitted && !touched)
          return null; // Skip error if untouched and not submitted
        return value == null || value.trim().isEmpty ? validatorMsg : null;
      },
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required String errorMsg,
    required TextEditingController controller,
    required bool touched,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled
          ? () {
              setState(() {
                if (label == 'Validity From') fromDateTouched = true;
                if (label == 'Validity To') toDateTouched = true;
              });
              onTap();
            }
          : null,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: _inputDecoration(label, icon).copyWith(
            fillColor: enabled ? Colors.grey.shade100 : Colors.grey.shade300,
          ),
          validator: (_) {
            if (!_submitted && !touched) return null;
            if (label == 'Validity To' && validityFrom == null) {
              return 'Select Validity From first';
            }
            return selectedDate == null ? errorMsg : null;
          },
          enabled: enabled,
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cancel Button
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            backgroundColor: Colors.white,
            labelColor: Colors.red.shade600,
            iconColor: Colors.red.shade600,
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
        ),
        const SizedBox(width: 16),
        // Submit Button
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.check_circle_outline,
            label: 'Submit',
            backgroundColor: Colors.indigo.shade700,
            labelColor: Colors.white,
            iconColor: Colors.white,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cancel Button
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            backgroundColor: Colors.white,
            labelColor: Colors.red.shade600,
            iconColor: Colors.red.shade600,
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
          ),
        ),
        const SizedBox(width: 16),
        // Submit Button
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.check_circle_outline,
            label: 'Submit',
            backgroundColor: Colors.indigo.shade700,
            labelColor: Colors.white,
            iconColor: Colors.white,
            onPressed: _handleSubmit,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color labelColor,
    required Color iconColor,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: iconColor),
        label: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: isOutlined
              ? BorderSide(color: Colors.grey.shade300)
              : BorderSide.none,
          elevation: isOutlined ? 0 : 4,
          shadowColor: Colors.black26,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      final voucherData = {
        'vendor': _truncate(vendorController.text),
        'customer': _truncate(customerNameController.text),
        'amount': amountController.text.trim(),
        'code': voucherCodeController.text.trim(),
        'validityFrom': _validityFromController.text,
        'validityTo': _validityToController.text,
      };
      _showSuccess('Voucher Submitted Successfully');
      Navigator.pop(context, voucherData);
    } else {
      _showError('Please fill all required fields correctly.');
    }
  }

  String _truncate(String value) {
    return value.length > 20 ? '${value.substring(0, 20)}...' : value;
  }
}
