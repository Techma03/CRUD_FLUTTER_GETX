import 'package:get/get.dart';

import '../modules/creditapp/bindings/creditapp_binding.dart';
import '../modules/creditapp/views/creditapp_view.dart';
import '../modules/crud/bindings/crud_binding.dart';
import '../modules/crud/views/crud_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/payapp/bindings/payapp_binding.dart';
import '../modules/payapp/views/payapp_view.dart';
import '../modules/todo/bindings/todo_binding.dart';
import '../modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CRUD,
      page: () => const CrudView(),
      binding: CrudBinding(),
    ),
    GetPage(
      name: _Paths.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: _Paths.PAYAPP,
      page: () => const PayappView(),
      binding: PayappBinding(),
    ),
    GetPage(
      name: _Paths.CREDITAPP,
      page: () => const CreditappView(),
      binding: CreditappBinding(),
    ),
  ];
}
