import 'package:get/get.dart';

import '../controllers/payapp_controller.dart';

class PayappBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayappController>(
      () => PayappController(),
    );
  }
}
