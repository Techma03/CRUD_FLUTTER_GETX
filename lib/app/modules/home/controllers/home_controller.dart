import 'package:crudapp/app/data/api_provider_provider.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class UserController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var user = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void fetchUser() async {
    final response = await _apiProvider.getUser();
    user.value = response.map((data) => User.fromJson(data)).toList();
  }

  void addUser(String name, String description) async {
    await _apiProvider.addUser(name, description);
    fetchUser();
  }

  void updateUser(int id, String name, String description) async {
    await _apiProvider.updateUser(id, name, description);
    fetchUser();
  }

  void deleteUser(int id) async {
    await _apiProvider.deleteUser(id);
    fetchUser();
  }
}
