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
      "date": date,
      "time": time,
      "is_completed": isCompleted ? 1 : 0,
    };
  }

  // Créer une tâche à partir d'un JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      isCompleted: json['is_completed'] == 1,
    );
  }
}
