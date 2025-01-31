import 'package:crudapp/app/modules/agents/controllers/agents_controller.dart';
import 'package:get/get.dart';

class CrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudController>(
      () => CrudController(),
    );
  }
}
