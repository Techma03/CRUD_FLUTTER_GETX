import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  TodoView({super.key});
  final taskTitleController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskDateController = TextEditingController();
  final taskTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.tasks.isEmpty) {
            return const Center(
              child: Text(
                "Aucune tâche pour le moment.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: GestureDetector(
                  onTap: () {
                    openTaskModal(
                      context,
                      isEdit: true,
                      index: index,
                    );
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        controller.toggleTaskCompletion(task.id!);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "${task.description}\n${task.date} - ${task.time}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.deleteTask(task.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openTaskModal(context);
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    if (taskTitleController.text.trim().isEmpty) {
      _showError("Veuillez entrer un titre.");
      return false;
    }
    if (taskDescriptionController.text.trim().isEmpty) {
      _showError("Veuillez entrer une description.");
      return false;
    }
    if (taskDateController.text.trim().isEmpty) {
      _showError("Veuillez sélectionner une date.");
      return false;
    }
    if (taskTimeController.text.trim().isEmpty) {
      _showError("Veuillez sélectionner une heure.");
      return false;
    }
    return true;
  }

  // Afficher un message d'erreur
  void _showError(String message) {
    Get.snackbar("Erreur", message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  void openTaskModal(BuildContext context, {bool isEdit = false, int? index}) {
    if (isEdit && index != null) {
      final task = controller.tasks[index];
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

  void _showTaskBottomSheet(BuildContext context, {required bool isEdit, int? index}) {
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
              const SizedBox(height: 16),
              _buildTextField(taskTitleController, "Titre", Icons.title),
              const SizedBox(height: 12),
              _buildTextField(taskDescriptionController, "Description", Icons.description),
              const SizedBox(height: 12),
              _buildTextField(taskDateController, "Date", Icons.calendar_today, true, () async {
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
              }),
              const SizedBox(height: 12),
              _buildTextField(taskTimeController, "Heure", Icons.access_time, true, () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  taskTimeController.text =
                      "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                }
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_validateFields(context)) {
                    if (isEdit && index != null) {
                      controller.updatedTask(
                        controller.tasks[index].id!,
                        taskTitleController.text,
                        taskDescriptionController.text,
                        taskDateController.text,
                        taskTimeController.text,
                      );
                    } else {
                      controller.addTask(
                        taskTitleController.text,
                        taskDescriptionController.text,
                        taskDateController.text,
                        taskTimeController.text,
                      );
                    }
                    Get.back();
                  }
                },
                child: Text(isEdit ? "Sauvegarder" : "Ajouter"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [bool readOnly = false, VoidCallback? onTap]) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}