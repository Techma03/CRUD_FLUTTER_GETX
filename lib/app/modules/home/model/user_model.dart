class User {
  final int id;
  final String name;
  final String description;

  User({
    required this.id,
    required this.name,
    required this.description,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
