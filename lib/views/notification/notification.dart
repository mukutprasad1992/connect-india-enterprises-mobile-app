import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/NotificationController.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/consts/appColors.dart';


class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final NotificationController controller =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notifications',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshNotifications),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
              child: Text("No notifications found",
                  style: TextStyle(color: Colors.grey)));
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final n = controller.notifications[index];
              final title = n.extractH3();
              final plainText = n.toPlainText();

              final subText = plainText.isNotEmpty
                  ? (plainText.length > 120
                      ? '${plainText.substring(0, 120)}...'
                      : plainText)
                  : 'No additional details';

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Material(
                  color: n.isRead == 1
                      ? Colors.white
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () =>
                        controller.markAsRead(n.id, index),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: n.isRead == 1
                                ? Colors.grey.shade200
                                : Colors.blue.shade100,
                            child: Icon(
                              n.isRead == 1
                                  ? Icons.notifications_none
                                  : Icons.notifications_active,
                              color: n.isRead == 1
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                                      fontSize: 13,
                                      color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        color: n.isRead == 1
                                            ? Colors.grey
                                            : Colors.blue,
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
          ),
        );
      }),
    );
  }
}
