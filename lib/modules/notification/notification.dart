import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/consts/appColors.dart';
import '/services/notificationServices/notificationApi.dart';
import '/models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<AppNotification>> futureNotifications;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    futureNotifications = NotificationService.getNotifications();
  }

  Future<void> refreshData() async {
    setState(() => isRefreshing = true);
    futureNotifications = NotificationService.getNotifications();
    setState(() => isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: refreshData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<AppNotification>>(
          future: futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !isRefreshing) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return _buildNotificationList(snapshot.data!);
            }
            return const Center(child: Text('No notifications found'));
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<AppNotification> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text('No notifications available'));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final n = notifications[index];

        // Use only <h3> as title
        //final title = n.extractTitle();
        final title = n.extractH3();

        // Subtitle should be message without <h3>
        final plainText = n.toPlainText();
        final subText = plainText.isNotEmpty
            ? (plainText.length > 100 ? '${plainText.substring(0, 100)}...' : plainText)
            : 'No additional details';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: n.isRead == 1 ? Colors.white : Colors.blue[50],
          child: ListTile(
            leading: Icon(
              n.isRead == 1 ? Icons.notifications : Icons.notifications_active,
              color: n.isRead == 1 ? Colors.blue : Colors.orange,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: n.isRead == 1 ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subText, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(n.email, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
            trailing: Text(
              timeago.format(n.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: n.isRead == 1 ? Colors.grey : Colors.blue,
                fontWeight: n.isRead == 1 ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            onTap: () {
              
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: refreshData, child: const Text('Retry')),
        ],
      ),
    );
  }
}
