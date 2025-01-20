import 'package:crudapp/app/modules/crud/controllers/crud_controller.dart';
import 'package:get/get.dart';

class CrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudController>(
      () => CrudController(),
    );
  }
}
