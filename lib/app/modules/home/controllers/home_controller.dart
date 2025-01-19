import 'package:flutter/material.dart';
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
    try {
      final response = await _apiProvider.getUser();
      user.value = response.map((data) => User.fromJson(data)).toList();
    } catch (e) {
      Get.snackbar(
        "Erreur", "Échec du chargement des utilisateurs.",
         backgroundColor: Colors.red,
         colorText: Colors.white,
      );
    }
  }

  void addUser(String name, String description) async {
  try {
    final Map<String, dynamic>? newUser = await _apiProvider.addUser(name, description);

    if (newUser != null) {
      user.add(User.fromJson(newUser)); // Use safely since it's checked for null
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
  } catch (e) {
    print("Erreur lors de l'ajout de l'utilisateur : $e");
    Get.snackbar(
      "Erreur de Connexion", 
      "Échec de l'ajout de l'utilisateur.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
   fetchUser();
}


  void updateUser(int id, String name, String description) async {
    try {
      final updatedUser = await _apiProvider.updateUser(id, name, description);
      final index = user.indexWhere((u) => u.id == id);
      if (index != -1) {
        user[index] = User.fromJson(updatedUser!); // Met à jour localement.
        
      }
    } catch (e) {
     
    }
    fetchUser();
  }

  void deleteUser(int id) async {
    print(id);
    try {
      final success = await _apiProvider.deleteUser(id);
      if (success) {
        user.removeWhere((u) => u.id == id); // Supprime localement.
          
      }
    } catch (e) {
      Get.snackbar("Erreur de Connexion", "Échec de la suppression de l'utilisateur.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    fetchUser();     
  }
}
