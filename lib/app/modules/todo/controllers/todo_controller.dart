import 'package:crudapp/app/data/api_provider.dart';
import 'package:crudapp/app/modules/todo/model/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Contrôleur pour la gestion des tâches
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

  // Obtenir toutes les tâches
  void fetchTasks() async {
    final response = await _apiProvider.getTask();
    tasks.value = response.map((data) => Task.fromJson(data)).toList();
  }

  // Ajouter une tâche
  Future<void> addTask(
      String title, String description, String date, String time) async {
    final Map<String, dynamic>? newTask =
        await _apiProvider.addTask(title, description, date, time);
    if (newTask != null) {
      tasks.add(Task.fromJson(newTask));
    } else {
      throw Exception("Tache ajouter Null");
    }
    fetchTasks();
  }

  // Modifier une tâche
  Future<void> updatedTask(int id, String title, String description,
      String date, String time) async {
    final updatedTask =
        await _apiProvider.updatedTask(id, title, description, date, time);
    final index = tasks.indexWhere((u) => u.id == id);
    if (index != -1) {
      tasks[index] = Task.fromJson(updatedTask!);
    }
    fetchTasks();
  }

  // Supprimer une tâche
  void deleteTask(int id) async {
    final success = await _apiProvider.deleteTask(id);
    if (success) {
      tasks.removeWhere((u) => u.id == id);
    }
    fetchTasks();
  }

  Future<void> toggleTaskCompletion(int index) async {
    try {
      // Récupérer la tâche sélectionnée
      final task = tasks[index];
      task.isCompleted = !task.isCompleted;
      // Appeler l'API pour mettre à jour le statut d'achèvement
      final updatedTaskJson = await _apiProvider.toggleTaskCompletion(index);
      // Trouver l'index de la tâche mise à jour
      final taskIndex = tasks.indexWhere((u) => u.id == task.id);
      if (taskIndex != -1 && updatedTaskJson != null) {
        // Mettre à jour la tâche dans la liste locale
        tasks[taskIndex] = Task.fromJson(updatedTaskJson);
        tasks.refresh(); // Rafraîchir la liste observable
      }
    } catch (e) {
      // Gérer les erreurs
      Get.snackbar(
        "Erreur",
        "Impossible de mettre à jour la tâche: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Basculer l'état d'achèvement

  // Valider les champs de texte
  bool _validateFields(BuildContext context) {
    if (taskTitleController.text.trim().isEmpty) {
      _showError(context, "Veuillez entrer un titre.");
      return false;
    }
    if (taskDescriptionController.text.trim().isEmpty) {
      _showError(context, "Veuillez entrer une description.");
      return false;
    }
    if (taskDateController.text.trim().isEmpty) {
      _showError(context, "Veuillez sélectionner une date.");
      return false;
    }
    if (taskTimeController.text.trim().isEmpty) {
      _showError(context, "Veuillez sélectionner une heure.");
      return false;
    }
    return true;
  }

  // Afficher un message d'erreur
  void _showError(BuildContext context, String message) {
    Get.snackbar(
      "Erreur",
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
   // Ouvrir le modal d'ajout ou d'édition
  void openTaskModal(BuildContext context, {bool isEdit = false, int? index}) {
    if (isEdit && index != null) {
      final task = tasks[index];
      taskTitleController.text = task.title;
      taskDescriptionController.text = task.description;
      taskDateController.text = task.date;
      taskTimeController.text = task.time;
    } else {
      taskTitleController.clear();
      taskDescriptionController.clear();
      taskDateController.clear();
      taskTimeController.clear();
    }

    _showTaskBottomSheet(context, isEdit: isEdit, index: index);
  }

void _showTaskBottomSheet(BuildContext context,
      {required bool isEdit, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                isEdit ? "Modifier la tâche" : "Ajouter une tâche",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: taskTitleController,
                label: "Titre",
                icon: Icons.title,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: taskDescriptionController,
                label: "Description",
                icon: Icons.description,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: taskDateController,
                label: "Date",
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    taskDateController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: taskTimeController,
                label: "Heure",
                icon: Icons.access_time,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    taskTimeController.text =
                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isEdit && index != null) {
                        //updatedTask(context, index);
                      } else {
                       //addTask(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEdit ? "Sauvegarder" : "Ajouter",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
