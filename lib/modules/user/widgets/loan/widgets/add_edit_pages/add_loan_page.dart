import 'package:flutter/material.dart';
import '/modules/user/widgets/loan/widgets/form_loan/loanHorzontle.dart';

class AddLoanPage extends StatelessWidget {
  final String token;
  //final String tempSelection;

  const AddLoanPage({
    super.key, 
    //required this.tempSelection,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return StepperFormPage(
      //loanType:tempSelection,
      mode: "add",
      token: token,
      submit: "0",
      
    );
  }
}
