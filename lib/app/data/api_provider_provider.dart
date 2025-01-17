import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProvider {
  final String baseUrl = "http://192.168.169.4/techapp";

  Future<List<dynamic>> getUser() async {
    final response = await http.get(Uri.parse("$baseUrl/data.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

 Future<Map<String, dynamic>?> addUser(String name, String description) async {
  final response = await http.post(
    Uri.parse("$baseUrl/data.php"),
    headers: {'Content-Type': 'application/json'}, // Indique que les données sont en JSON
    body: jsonEncode({'name': name, 'description': description}),
  );

  if (response.statusCode == 200) {
    // Parse et retourne la réponse en cas de succès
    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    // Mauvaise entrée
    throw Exception("Invalid input: ${response.body}");
  } else if (response.statusCode == 500) {
    // Erreur serveur
    throw Exception("Server error: ${response.body}");
  } else {
    // Autres erreurs
    throw Exception("Unexpected error: ${response.statusCode}");
  }
}


  Future<Map<String, dynamic>?> updateUser(
      int id, String name, String description) async {
    final response = await http.put(
      Uri.parse("$baseUrl/data.php/$id"),
      body: {'name': name, 'description': description},
      
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
      
    } else {
      throw Exception("Failed to update user");
    }
  }

 Future<bool> deleteUser(int id) async {
  final response = await http.delete(
    Uri.parse("$baseUrl/data.php"), // Assurez-vous que le point d'entrée est correct
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    Get.snackbar("Succès", "Utilisateur supprimé avec succès.",
         backgroundColor: Colors.green,
         colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM
            );
    return responseBody['success'] == true;
    
  } else {
     
    throw Exception(
      Get.snackbar("Erreur de Connexion", "Échec de la suppression de l'utilisateur.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      )
    );
  }
}

}
