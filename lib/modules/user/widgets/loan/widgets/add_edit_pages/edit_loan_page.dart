import 'package:flutter/material.dart';
import '/modules/user/widgets/loan/widgets/form_loan/loanHorzontle.dart';
import '/models/loanModel.dart';

class EditLoanPage extends StatefulWidget {
  final LoanModel loan;
  final String token;

  const EditLoanPage({
    super.key,
    required this.loan,
    required this.token
  });

  @override
  State<EditLoanPage> createState() => _EditLoanPageState();
} 

class _EditLoanPageState extends State<EditLoanPage> {
  @override
  Widget build(BuildContext context) {
    return StepperFormPage(
      mode: "edit",
      loan: widget.loan,
      token: widget.token,
      submit: widget.loan.submit.toString(),
    );
  }
}
