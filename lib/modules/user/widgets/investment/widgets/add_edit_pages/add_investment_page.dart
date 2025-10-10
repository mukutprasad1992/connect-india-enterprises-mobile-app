import 'package:flutter/material.dart';
import '/modules/user/widgets/investment/widgets/form_investment/investmentHorzontle.dart';

class AddInvestmentPage extends StatelessWidget {
  final String token;
  //final String tempSelection;

  const AddInvestmentPage({
    super.key, 
    //required this.tempSelection,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return StepperFormPage(
      //investmentType:tempSelection,
      mode: "add",
      token: token,
      submit: "0",
      
    );
  }
}
