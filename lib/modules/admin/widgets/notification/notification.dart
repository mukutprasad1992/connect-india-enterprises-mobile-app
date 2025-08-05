import 'package:flutter/material.dart';
import '/consts/appColors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Welcome!',
      'subtitle': 'Thank you for signing up. Let\'s get started.',
      'time': '10 mins ago'
    },
    {
      'title': 'New Offer',
      'subtitle': 'Get 20% off on your next purchase.',
      'time': '1 hour ago'
    },
    {
      'title': 'Security Alert',
      'subtitle': 'New login from a different device.',
      'time': 'Yesterday'
    },
    {
      'title': 'Update Available',
      'subtitle': 'A new version of the app is available to download.',
      'time': '2 days ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notifications',style: TextStyle(color:Colors.white),),
        backgroundColor: AppColors.background,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: Text(notification['title'] ?? ''),
              subtitle: Text(notification['subtitle'] ?? ''),
              trailing: Text(
                notification['time'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
