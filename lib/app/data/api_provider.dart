import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProvider {
  final String baseUrl = "http://192.168.71.4/techapp";
  Future<List<dynamic>> getAgent() async {
    final response = await http.get(Uri.parse("$baseUrl/agents/data.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load Agents");
    }
  }

  Future<Map<String, dynamic>?> addAgent(String name, String description) async {
    final response = await http.post(
      Uri.parse("$baseUrl/agents/data.php"),
      headers: {
        'Content-Type': 'application/json'
      }, // Indique que les données sont en JSON
      body: jsonEncode({'name': name, 'description': description}),
    );

    if (response.statusCode == 200) {
       Get.snackbar(
        "Succès",
        "Agent ajouté avec succès.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return jsonDecode(response.body);      
    } else if (response.statusCode == 400) {
      throw Exception("Invalid input: ${response.body}");
    } else if (response.statusCode == 500) {
      throw Exception("Server error: ${response.body}");
    } else {
      throw Exception("Unexpected error: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>?> updateAgent(
      int id, String name, String description) async {
    final url = Uri.parse("$baseUrl/agents/data.php");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'name': name, 'description': description}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("Mise à jour réussie : $responseBody");
          Get.snackbar(
            "Succès",
            "Agent modifié avec succès.",
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return responseBody;
        } else {
          print("Échec de la mise à jour : ${responseBody['message']}");
          Get.snackbar(
            "Erreur",
            "Échec de la mise à jour de l'Agent : ${responseBody['message']}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
      } else {
        print("Erreur HTTP : ${response.statusCode}");
        Get.snackbar(
          "Erreur",
          "Erreur HTTP : ${response.statusCode}.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      print("Exception : $e");
      Get.snackbar(
        "Erreur",
        "Une erreur s'est produite : $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<bool> deleteAgent(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/agents/data.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      Get.snackbar("Succès", "Agent supprimé avec succès.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return responseBody['success'] == true;
    } else {
      throw Exception(Get.snackbar(
        "Erreur de Connexion",
        "Échec de la suppression de l'Agent.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      ));
    }
  }

  //API TODO-LIST

  Future<List<dynamic>> getTask() async {
    final response = await http.get(Uri.parse("$baseUrl/todo/data.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load Agents");
    }
  }

  Future<Map<String, dynamic>?> addTask(
      String title, String description, String date, String time) async {
    final response = await http.post(
      Uri.parse("$baseUrl/todo/data.php"),
      headers: {
        'Content-Type': 'application/json'
      }, // Indique que les données sont en JSON
      body: jsonEncode({
        'title': title,
        'description': description,
        'date': date,
        'time': time
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Invalid input: ${response.body}");
    } else if (response.statusCode == 500) {
      throw Exception("Server error: ${response.body}");
    } else {
      throw Exception("Unexpected error: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>?> updatedTask(int id, String title,
      String description, String date, String time) async {
    final url = Uri.parse("$baseUrl/todo/data.php");
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'titre': title,
          'description': description,
          'date': date,
          'time': time
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          print("Mise à jour réussie : $responseBody");
          Get.snackbar(
            "Succès",
            "Tache modifié avec succès.",
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return responseBody;
        } else {
          print("Échec de la mise à jour : ${responseBody['message']}");
          Get.snackbar(
            "Erreur",
            "Échec de la mise à jour de la tache : ${responseBody['message']}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return null;
        }
      } else {
        print("Erreur HTTP : ${response.statusCode}");
        Get.snackbar(
          "Erreur",
          "Erreur HTTP : ${response.statusCode}.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }
    } catch (e) {
      print("Exception : $e");
      Get.snackbar(
        "Erreur",
        "Une erreur s'est produite : $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> toggleTaskCompletion(int taskId) async {
    final url = Uri.parse('$baseUrl/todo/data.php');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': taskId,
        }),
      );
      if (response.statusCode == 200) {
        // Retourner les données JSON si la requête réussit
        return jsonDecode(response.body);
      } else {
        // Gestion des erreurs côté serveur
        throw Exception('Erreur du serveur: ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs réseau ou autres
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<bool> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/todo/data.php"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      Get.snackbar("Succès", "Tache supprimé avec succès.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return responseBody['success'] == true;
    } else {
      throw Exception(Get.snackbar(
        "Erreur de Connexion",
        "Échec de la suppression de la tache.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      ));
    }
  }
}
