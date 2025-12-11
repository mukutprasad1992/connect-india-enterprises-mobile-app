import 'dart:async';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '/modules/user/widgets/loan/widgets/form_loan/loanHorzontle.dart';
import '/models/loanModel.dart';

Future<bool?> showLoanTypeDialog({
  required BuildContext context,
  required String mode,
  required String token,
  required String submit,
  final LoanModel? loan,
  Function()? onAnySectionSaved,
  required Function(Map<String, dynamic>) onSubmit,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent.withOpacity(0.15),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.blueAccent, size: 24),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Select Loan Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Dropdown
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: tempSelection,
                        hint: const Text(
                          "Choose Loan Type",
                          style: TextStyle(color: Colors.black54),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(14),
                        isExpanded: true,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                        items: const ["Personal loans"]
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
                          setState(() {
                            tempSelection = val;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.close,
                            color: Colors.redAccent, size: 18),
                        label: const Text("Cancel",
                            style: TextStyle(color: Colors.redAccent)),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!completer.isCompleted) completer.complete(false);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.white),
                        label: const Text("Next",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: Colors.blueAccent.withOpacity(0.4),
                        ),
                        onPressed: () {
                          if (tempSelection == null || tempSelection!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a loan type"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          // close dialog first
                          Navigator.pop(context);

                          // open stepper and forward the onAnySectionSaved callback
                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StepperFormPage(
                                mode: mode,
                                token: token,
                                submit: submit,
                                loan: loan,
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

  // OPTIONAL fallback timeout (uncomment if you want a safety timeout)
  // Future.delayed(const Duration(seconds: 6), () {
  //   if (!completer.isCompleted) completer.complete(false);
  // });

  return completer.future;
}
