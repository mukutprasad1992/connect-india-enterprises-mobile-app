import 'package:get/get.dart';
import 'package:myapp/controllers/myProfileController.dart';


class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(), permanent: true);
  }
}