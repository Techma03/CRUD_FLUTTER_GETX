import 'package:crudapp/app/data/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:crudapp/app/modules/todo/model/task_model.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  final tasks = <Task>[].obs;
  final ApiProvider _apiProvider = ApiProvider();

  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskDateController = TextEditingController();
  final taskTimeController = TextEditingController();
@override
  void onInit() {
    super.onInit();
    fetchTasks();
  }
   @override
  void onClose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    taskDateController.dispose();
    taskTimeController.dispose();
    super.onClose();
  }

  // Obtenir toutes les tâches
  void fetchTasks() async {
    try {
      final response = await _apiProvider.getTask();
      tasks.value = response.map((data) => Task.fromJson(data)).toList();
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de récupérer les tâches : $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Ajouter une tâche
  Future<void> addTask(
      String title, String description, String date, String time) async {
    try {
      final newTask = await _apiProvider.addTask(title, description, date, time);
      if (newTask != null) {
        tasks.add(Task.fromJson(newTask));
        fetchTasks();
      } else {
        throw Exception("Tâche ajoutée null");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Échec de l'ajout de la tâche : $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Modifier une tâche
  Future<void> updatedTask(
      int id, String title, String description, String date, String time) async {
    try {
      final updatedTask = await _apiProvider.updatedTask(id, title, description, date, time);
      final index = tasks.indexWhere((u) => u.id == id);
      if (index != -1 && updatedTask != null) {
        tasks[index] = Task.fromJson(updatedTask);
        fetchTasks();
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de modifier la tâche : $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Supprimer une tâche
  Future<void> deleteTask(int id) async {
    try {
      final success = await _apiProvider.deleteTask(id);
      if (success) {
        tasks.removeWhere((u) => u.id == id);
        fetchTasks();
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de supprimer la tâche : $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Basculer l'état d'achèvement
  Future<void> toggleTaskCompletion(int id) async {
    try {
      final index = tasks.indexWhere((task) => task.id == id);
      if (index == -1) return;

      final updatedTaskJson = await _apiProvider.toggleTaskCompletion(id);
      if (updatedTaskJson != null) {
        tasks[index] = Task.fromJson(updatedTaskJson);
        tasks.refresh();
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de mettre à jour la tâche : $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
 }
