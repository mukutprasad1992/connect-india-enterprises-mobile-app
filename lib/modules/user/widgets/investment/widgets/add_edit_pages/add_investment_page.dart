import 'package:flutter/material.dart';
import '/modules/user/widgets/investment/widgets/form_investment/investment_form_page.dart';

class AddInvestmentPage extends StatelessWidget {
  final String token;
  //final String  isDetailsConfirmed;

  const AddInvestmentPage({
    super.key, 
    required this.token,
    //required this.isDetailsConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return InvestmentFormPage(

      mode: "add",
      token: token,
       isDetailsConfirmed: "0",
      
    );
  }
}
