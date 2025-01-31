class Agent {
  final int id;
  final String name;
  final String description;

  Agent({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
