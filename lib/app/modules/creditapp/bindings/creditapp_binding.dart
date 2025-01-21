import 'package:get/get.dart';

import '../controllers/creditapp_controller.dart';

class CreditappBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditappController>(
      () => CreditappController(),
    );
  }
}
