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
        title:
            const Text('Notifications', style: TextStyle(color: Colors.white)),
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
            if (snapshot.connectionState == ConnectionState.waiting &&
                !isRefreshing) {
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
      return const Center(
        child: Text(
          'No notifications available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final n = notifications[index];

        // Title only from <h3>
        final title = n.extractH3();

        // Plain message without <h3>
        final plainText = n.toPlainText();
        final subText = plainText.isNotEmpty
            ? (plainText.length > 120
                ? '${plainText.substring(0, 120)}...'
                : plainText)
            : 'No additional details';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Material(
            color: n.isRead == 1 ? Colors.white : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                if (n.isRead == 0) {
                  try {
                    await NotificationService.markAsRead(n.id); 
                    setState(() {
                      n.isRead = 1; 
                    });
                  } catch (e) {
                    print('Mark as read failed: $e');
                    // Optional: show a snackbar to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to mark notification as read')),
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leading Icon
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: n.isRead == 1
                          ? Colors.grey.shade200
                          : Colors.blue.shade100,
                      child: Icon(
                        n.isRead == 1
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: n.isRead == 1 ? Colors.grey : Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title + subtitle + email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: n.isRead == 1
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subText,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                n.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                timeago.format(n.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      n.isRead == 1 ? Colors.grey : Colors.blue,
                                  fontWeight: n.isRead == 1
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
