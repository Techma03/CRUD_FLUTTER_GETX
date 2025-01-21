import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crudapp/app/modules/todo/model/task_model.dart';

// Contrôleur pour gérer la logique de l'application
class TodoController extends GetxController {
  final tasks = <Task>[].obs;
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskDateController = TextEditingController();
  final taskTimeController = TextEditingController();

  // Ajouter une tâche avec validation
  void addTask(BuildContext context) {
    if (_validateFields(context)) {
      tasks.add(
        Task(
          title: taskTitleController.text.trim(),
          description: taskDescriptionController.text.trim(),
          date: taskDateController.text.trim(),
          time: taskTimeController.text.trim(),
        ),
      );
      Get.back();
    }
  }

  // Modifier une tâche avec validation
  void editTask(BuildContext context, int index) {
    if (_validateFields(context)) {
      tasks[index].title = taskTitleController.text.trim();
      tasks[index].description = taskDescriptionController.text.trim();
      tasks[index].date = taskDateController.text.trim();
      tasks[index].time = taskTimeController.text.trim();
      tasks.refresh();
      Get.back();
    }
  }

  // Supprimer une tâche
  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  // Basculer l'état d'achèvement d'une tâche
  void toggleTaskCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    tasks.refresh();
  }

  // Valider les champs de texte
  bool _validateFields(BuildContext context) {
    if (taskTitleController.text.trim().isEmpty) {
      _showError(context, "Veuillez entrer un titre.");
      return false;
    }
    if (taskDescriptionController.text.trim().isEmpty) {
      _showError(context, "Veuillez sélectionner une description.");
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

  // Afficher le BottomSheet
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        editTask(context, index);
                      } else {
                        addTask(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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

  // Widget pour un champ de texte
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
