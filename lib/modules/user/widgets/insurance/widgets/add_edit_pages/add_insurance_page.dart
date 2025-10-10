import 'package:flutter/material.dart';
import '/modules/user/widgets/insurance/widgets/form_insurance/insuranceHorzontle.dart';

class AddInsurancePage extends StatelessWidget {
  final String token;

  const AddInsurancePage({
    super.key, 
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return StepperFormPage(
      mode: "add",
      token: token,
      submit: "0",
      
    );
  }
}
