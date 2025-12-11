import 'package:html/parser.dart' as html_parser;

class AppNotification {
  final String id;
  final String message;
  int isRead; // mutable so UI can update
  final DateTime createdAt;
  final String email;

  AppNotification({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.email,
  });

  /// Convert API JSON → Model
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      message: json['message'] ?? '',
      isRead: int.tryParse(json['isRead']?.toString() ?? "0") ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      email: json['email'] ?? '',
    );
  }

  /// Extract only <h3> title from HTML message
  String extractH3() {
    final document = html_parser.parse(message);
    final h3Elements = document.getElementsByTagName('h3');

    if (h3Elements.isNotEmpty) {
      return h3Elements.first.text.trim();
    }

    // Fallback default title
    return 'Notification';
  }

  /// Convert HTML message → Plain text
  String toPlainText() {
    final document = html_parser.parse(message);
    final bodyText = document.body?.text ?? '';

    // Remove extra whitespace
    return bodyText.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
