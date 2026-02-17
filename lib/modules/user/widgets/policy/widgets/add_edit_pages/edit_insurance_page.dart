import 'package:flutter/material.dart';
import '/modules/user/widgets/insurance/widgets/form_insurance/insuranceHorzontle.dart';
import '/models/insuranceModel.dart';

class EditInsurancePage extends StatefulWidget {
  final InsuranceModel insurance;
  final String token;

  const EditInsurancePage({
    super.key,
    required this.insurance,
    required this.token
  });

  @override
  State<EditInsurancePage> createState() => _EditInsurancePageState();
} 

class _EditInsurancePageState extends State<EditInsurancePage> {
  @override
  Widget build(BuildContext context) {
    return StepperFormPage(
      mode: "edit",
      insurance: widget.insurance,
      token: widget.token,
      submit: widget.insurance.submit.toString(),
    );
  }
}
