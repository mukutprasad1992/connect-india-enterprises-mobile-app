import 'package:get/get.dart';
import 'package:myapp/services/notificationServices/notificationApi.dart';
import 'package:myapp/services/notificationServices/notification_updateisRead.dart' ;
import '/models/notification_model.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxList<AppNotification> notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  // Fetch all notifications
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await NotificationService.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull to refresh
  Future<void> refreshNotifications() async {
    isRefreshing.value = true;
    await fetchNotifications();
    isRefreshing.value = false;
  }

  // Mark notification as read using PUT API
  Future<void> markAsRead(String id, int index) async {
    try {
      bool success = await ReadNotification.updateReadNotification(id);

      if (success) {
        notifications[index].isRead = 1;
        notifications.refresh();
      } else {
        Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to mark as read");
    }
  }
}
