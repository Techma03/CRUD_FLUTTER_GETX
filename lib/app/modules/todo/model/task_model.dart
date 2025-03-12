// Modèle de tâche
class Task {
  int? id;
  String title;
  String description;
  String date;
  String time;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  // Convertir une tâche en JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "created_date": date,
      "created_time": time,
      "is_completed": isCompleted ? 1 : 0,
    };
  }

  // Créer une tâche à partir d'un JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['created_date'] ?? '',
      time: json['created_time'] ?? '',
      isCompleted: json['is_completed'] == 1,
    );
  }
}
