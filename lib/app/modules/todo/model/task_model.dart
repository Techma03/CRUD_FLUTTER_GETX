class Task {
  String title;
  String description;
  String date;
  String time;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });
}
