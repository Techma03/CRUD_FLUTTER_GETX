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
      name: json['name'] ?? 'Inconnu', // Valeur par défaut pour un String
      description: json['description'] ?? 'Aucune description', // Valeur par défaut pour un String
    );
  }
}
