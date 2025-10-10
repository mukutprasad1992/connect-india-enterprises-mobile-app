import 'package:flutter/material.dart';
import '/modules/user/widgets/investment/widgets/form_investment/investmentHorzontle.dart';
import '/models/investmentModel.dart';
import '/modules/user/widgets/investment/investment.dart';

Future<void> showInvestmentTypeDialog(
    {required BuildContext context,
    required String mode,
    required String token,
    required String submit,
    final InvestmentModel? investment,
    required Function(Map<String, dynamic>) onSubmit}) async {
  String? tempSelection;
  //onSubmit(newInvestmentData);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: const [
                Icon(Icons.account_balance_wallet, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Select Investment Type",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            content: DropdownButtonFormField<String>(
              value: tempSelection,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Investment Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                //prefixIcon: const Icon(Icons.trending_up),
              ),
              items: ["Mutual Funds"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  tempSelection = val;
                });
              },
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  if (tempSelection == null || tempSelection!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select investment type"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  // open stepper form
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepperFormPage(
                        mode: mode,
                        token: token,
                        submit: submit,
                        investment: investment,
                        
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
