import 'package:flutter/material.dart';
//import '/modules/user/widgets/investment/widgets/form_investment/investment_form_page.dart';
//import '/modules/user/widgets/investment/widgets/investment_models/Investment_model.dart';
import '/modules/user/widgets/investment/widgets/form_investment/investmentHorzontle.dart';
import '/models/investmentModel.dart';

class EditInvestmentPage extends StatefulWidget {
  final InvestmentModel investment;
  final String token;

  const EditInvestmentPage({
    super.key,
    required this.investment,
    required this.token
  });

  @override
  State<EditInvestmentPage> createState() => _EditInvestmentPageState();
} 

class _EditInvestmentPageState extends State<EditInvestmentPage> {
  @override
  Widget build(BuildContext context) {
    return InvestmentFormPage(
      mode: "edit",
      investment: widget.investment,
      token: widget.token,
      submit: widget.investment.submit.toString(),
    );
  }
}
