import 'package:flutter/material.dart';
import '/modules/user/widgets/insurance/widgets/form_insurance/insuranceHorzontle.dart';
import '/models/insuranceModel.dart';
import '/modules/user/widgets/insurance/insurance.dart';

Future<void> showInsuranceTypeDialog(
    {required BuildContext context,
    required String mode,
    required String token,
    required String submit,
    final InsuranceModel? insurance,
    required Function(Map<String, dynamic>) onSubmit}) async {
  String? tempSelection;
  

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
                  "Select Insurance Type",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            content: DropdownButtonFormField<String>(
              value: tempSelection,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Insurance Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                //prefixIcon: const Icon(Icons.trending_up),
              ),
              items: ["Life Insurance "]
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
                        content: Text("Please select insurance type"),
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
                        insurance: insurance,
                        
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
