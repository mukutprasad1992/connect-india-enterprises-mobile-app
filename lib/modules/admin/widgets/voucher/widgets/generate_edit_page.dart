import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/Vendor_model.dart';
// import 'package:myapp/models/customerModel.dart';
import 'package:myapp/models/vendor_module/vendor_customer_model.dart';
import '/consts/appColors.dart';
// import '/models/createVouchermodel.dart';
import '/controllers/adminController/voucher/voucher_Validator.dart';
import '/services/admin_module_service_Api/voucher/createVoucher.dart';
import '/services/admin_module_service_Api/voucher/updateVoucher.dart';
import '/services/admin_module_service_Api/vendor/getallvendor.dart';
import '/services/vendor_module_service_Api/Vendor_customer/getAll_customerByvendor_Id.dart';
import 'package:intl/intl.dart';

class GenerateEditVoucherPage extends StatefulWidget {
  final String mode;
  final String? dbId;
  final Map<String, dynamic> CreateVoucherModel;
  final Function(String dbId) onCompleted;
  final VoidCallback? onReloadParent;

  const GenerateEditVoucherPage({
    Key? key,
    required this.mode,
    required this.CreateVoucherModel,
    this.dbId,
    required this.onCompleted,
    this.onReloadParent,
  }) : super(key: key);

  @override
  _GenerateEditVoucherPageState createState() =>
      _GenerateEditVoucherPageState();
}

class _GenerateEditVoucherPageState extends State<GenerateEditVoucherPage> {
  final _formKey = GlobalKey<FormState>();

  //final TextEditingController vendorId = TextEditingController();
  //final TextEditingController customerId = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController voucherCodeController = TextEditingController();
  final TextEditingController validityFromController = TextEditingController();
  final TextEditingController validityToController = TextEditingController();

  bool _isLoading = false;
  String? dbId;
  String? selectedVendor;
  List<VendorModel> vendorList = [];
  String? selectedCustomer;
  List<VendorCustomerModel> customerList = [];

  bool isLoadingVendors = true;
  bool isLoadingCustomers = false;

  DateTime? _validityFrom;
  DateTime? _validityTo;

  Future<void> _loadVendors() async {
    try {
      List<VendorModel> vendors = await GetAllVendorApi.getAllvendor();
      setState(() {
        vendorList = vendors;
        isLoadingVendors = false;
      });
    } catch (e) {}
  }

  Future<void> _loadCustomers(String vendorId) async {
    setState(() {
      isLoadingCustomers = true;
      customerList = [];
      selectedCustomer = null;
    });
    try {
      List<VendorCustomerModel> customers =
          await GetAllVendorCustomer.getAllCustomerByVendorId(
              vendorId: vendorId);
      setState(() {
        customerList = customers;
      });
    } catch (e) {
    } finally {
      setState(() {
        isLoadingCustomers = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVendors();
    if (widget.mode == "edit" && widget.CreateVoucherModel.isNotEmpty) {
      _prefillVendorData();
    }
  }

  String? formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(isoString));
    } catch (_) {
      return '';
    }
  }

  void _prefillVendorData() async {
    try {
      final ven = widget.CreateVoucherModel;
      dbId = widget.dbId ?? ven["id"]?.toString() ?? ven["_id"]?.toString();
      selectedVendor = ven["vendorId"]?.toString() ?? '';
      // selectedCustomer = ven["customerId"]?.toString() ?? '';
      amountController.text = ven["amount"]?.toString() ?? '';
      voucherCodeController.text = ven["voucherCode"]?.toString() ?? '';
      validityFromController.text =
          formatDate(ven["validityFrom"]?.toString()) ?? '';
      validityToController.text =
          formatDate(ven["validityTo"]?.toString()) ?? '';
      if (selectedVendor!.isNotEmpty) {
        await _loadCustomers(selectedVendor!);
        setState(() {
          selectedCustomer = ven["customerId"]?.toString() ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Prefill error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    selectedVendor;
    selectedCustomer;
    amountController.dispose();
    voucherCodeController.dispose();
    validityFromController.dispose();
    validityToController.dispose();
    super.dispose();
  }

  void _cancel() => Navigator.pop(context);

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _validityFrom ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _validityFrom = picked;
        validityFromController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (_validityFrom == null) {
      _showError("Please select 'Validity From' first");
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _validityTo ?? _validityFrom!.add(const Duration(days: 1)),
      firstDate: _validityFrom!,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _validityTo = picked;
        validityToController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitVendor() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final vendorIdInt = int.tryParse(selectedVendor!);
      final customerIdInt = int.tryParse(selectedCustomer!);
      final amountDouble = double.tryParse(amountController.text.trim());

      if (vendorIdInt == null ||
          customerIdInt == null ||
          amountDouble == null) {
        throw Exception("Vendor, Customer Name, and Amount must be numbers");
      }

      Map<String, dynamic> result;

      if (widget.mode == "add") {
        result = await CreateVoucher.createVoucher(
          vendorId: vendorIdInt,
          customerId: customerIdInt,
          amount: amountDouble,
          voucherCode: voucherCodeController.text.trim(),
          validityFrom: validityFromController.text.trim(),
          validityTo: validityToController.text.trim(),
        );

        if (result["status"] == true) {
          dbId = result["data"]?["id"]?.toString() ?? "unknown";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Voucher successfully added!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception(result["message"] ?? "Failed to create voucher");
        }
      } else {
        if (dbId == null) throw Exception("Missing voucher ID for update");

        result = await UpdateVoucher.updateVoucherById(
          id: int.parse(dbId!),
          vendorId: vendorIdInt,
          customerId: customerIdInt,
          amount: amountDouble,
          voucherCode: voucherCodeController.text.trim(),
          validityFrom: validityFromController.text.trim(),
          validityTo: validityToController.text.trim(),
        );

        if (result["status"] == true) {
          // ✅ Call parent reload
          // await widget.onReloadParent?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Voucher successfully updated!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception(result["message"] ?? "Failed to update voucher");
        }
      }

      widget.onCompleted(dbId!.toString());
      Future.delayed(const Duration(milliseconds: 400), () {
        Navigator.pop(context, dbId);
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool required = false, String? prefixText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 18),
      prefixText: prefixText,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          if (required)
            const Text(" *", style: TextStyle(color: Colors.red, fontSize: 13)),
        ],
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      readOnly: readOnly || onTap != null,
      onTap: onTap,
      decoration: _inputDecoration(label, icon, required: true),
      validator: validator,
    );
  }

 

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancel,
            icon: const Icon(Icons.cancel, color: Colors.white),
            label: const Text('Cancel',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _submitVendor,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline, color: Colors.white),
            label: Text(
              _isLoading
                  ? "Processing..."
                  : widget.mode == "add"
                      ? "Submit"
                      : "Update",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.mode == "add" ? Colors.indigo : Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
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
        title: Text(
          widget.mode == "add" ? 'Add New Voucher' : 'Edit Voucher',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
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
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Vendor', Icons.store, required: true),
                    value: selectedVendor,
                    items: vendorList.map((vendor) {
                      return DropdownMenuItem<String>(
                        value: vendor.id.toString(),
                        child: Text(vendor.businessName,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVendor = value;
                      });
                      if (value != null) {
                        _loadCustomers(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vendor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  isLoadingCustomers
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Customer Name', Icons.person, required: true),
                      value: selectedCustomer,
                      items: customerList.map((customer) {
                      return DropdownMenuItem<String>(
                        value: customer.id.toString(),
                        child: Text(customer.name ?? 'N/A',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCustomer = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select a customer' : null,
                    ),
                  const SizedBox(height: 18),

                  _buildTextField(
                    label: 'Amount',
                    icon: Icons.attach_money,
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'))
                    ],
                    validator: VoucherController.validateAmount,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Voucher Code',
                    icon: Icons.qr_code,
                    controller: voucherCodeController,
                    validator: VoucherController.validatevoucherCode,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Validity From',
                    icon: Icons.calendar_today,
                    controller: validityFromController,
                    validator: VoucherController.validatevalidityFrom,
                    onTap: () => _selectFromDate(context),
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Validity To',
                    icon: Icons.calendar_month,
                    controller: validityToController,
                    validator: VoucherController.validatevalidityTo,
                    onTap: () => _selectToDate(context),
                  ),
                  const SizedBox(height: 30),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
