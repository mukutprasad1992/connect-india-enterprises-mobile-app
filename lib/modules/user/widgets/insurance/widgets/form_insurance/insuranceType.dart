import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '/modules/user/widgets/insurance/widgets/form_insurance/insuranceHorzontle.dart';
import '/models/insuranceModel.dart';

Future<bool?> showInsuranceTypeDialog({
  required BuildContext context,
  required String mode,
  required String token,
  required String submit,
  final InsuranceModel? insurance,
  required Function(Map<String, dynamic>) onSubmit,
  Function()? onAnySectionSaved,
}) async {
  final Completer<bool?> completer = Completer<bool?>();

  String? tempSelection;

  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    animType: AnimType.bottomSlide,
    dismissOnTouchOutside: true,
    dialogBackgroundColor: Colors.white,
    padding: const EdgeInsets.all(14),

    body: StatefulBuilder(
      builder: (context, setState) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
              maxHeight: 350,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent.withOpacity(0.15),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.policy_outlined,
                            color: Colors.blueAccent, size: 24),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Select Insurance Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempSelection,
                        hint: const Text("Choose Insurance Type"),
                        items: const ["Life Insurance"]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    const Icon(Icons.policy_outlined,
                                        color: Colors.blueAccent, size: 18),
                                    const SizedBox(width: 8),
                                    Text(e),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => tempSelection = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        label: const Text("Cancel",
                            style: TextStyle(color: Colors.redAccent)),
                        onPressed: () {
                          if (!completer.isCompleted) completer.complete(false);
                          Navigator.pop(context);
                        },
                      ),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                        label: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          if (tempSelection == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select an insurance type"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context);

                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StepperFormPage(
                                mode: mode,
                                token: token,
                                submit: submit,
                                insurance: insurance,
                                onAnySectionSaved: onAnySectionSaved,
                              ),
                            ),
                          ).then((bool? result) {
                            if (!completer.isCompleted) {
                              completer.complete(result == true);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ).show();

  return completer.future;
}
