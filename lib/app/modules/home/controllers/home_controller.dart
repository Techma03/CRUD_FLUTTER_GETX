import 'package:flutter/material.dart';
import 'package:crudapp/app/data/api_provider.dart';
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
    final Map<String, dynamic>? newUser =
        await _apiProvider.addUser(name, description);
    if (newUser != null) {
      user.add(User.fromJson(newUser));
      Get.snackbar(
        "Succès",
        "Utilisateur ajouté avec succès.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      throw Exception("L'utilisateur ajouté est null.");
    }
    fetchUser();
  }

  void updateUser(int id, String name, String description) async {
    final updatedUser = await _apiProvider.updateUser(id, name, description);
    final index = user.indexWhere((u) => u.id == id);
    if (index != -1) {
      user[index] = User.fromJson(updatedUser!);
    }
    fetchUser();
  }

  void deleteUser(int id) async {
    final success = await _apiProvider.deleteUser(id);
    if (success) {
      user.removeWhere((u) => u.id == id);      
    }
    fetchUser();
  }
}
