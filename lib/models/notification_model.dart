import 'package:html/parser.dart' as html_parser;

class AppNotification {
  final int id;
  final String message;
  final int isRead;
  final DateTime createdAt;
  final String email;

  AppNotification({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.email,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      email: json['email'] ?? '',
    );
  }

  String extractH3() {
    final document = html_parser.parse(message);
    final h3 = document.getElementsByTagName('h3');
    if (h3.isNotEmpty) {
      return h3.first.text.trim();
    }
    return 'Notification'; 
  }

  String toPlainText() {
    final document = html_parser.parse(message);
    return document.body?.text.replaceAll(RegExp(r'\s+'), ' ').trim() ??'';
  }
}
