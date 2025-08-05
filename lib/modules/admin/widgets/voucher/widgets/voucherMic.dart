// // voucherMic.dart


// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class VoucherMic {
//   final stt.SpeechToText _speech = stt.SpeechToText();

//   Future<void> startListening(Function(String) onResult) async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => debugPrint('Speech status: $status'),
//       onError: (error) => debugPrint('Speech error: $error'),
//     );

//     if (available) {
//       _speech.listen(
//         onResult: (val) {
//           if (val.finalResult) {
//             onResult(val.recognizedWords);
//           }
//         },
//         listenFor: const Duration(seconds: 5),
//         cancelOnError: true,
//       );
//     } else {
//       debugPrint('Speech recognition not available');
//     }
//   }

//   void stopListening() {
//     _speech.stop();
//   }

//   bool isListening() {
//     return _speech.isListening;
//   }
// }
