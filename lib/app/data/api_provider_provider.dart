import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl = "http://192.168.175.4/techapp";
  Future<List<dynamic>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/data.php'));
    return json.decode(response.body);
  }

  Future<void> addItem(String name, String description) async {
    await http.post(Uri.parse('$baseUrl/data.php'), body: json.encode({
      'name': name,
      'description': description,
    }));
  }
  
  Future<void> updateItem(int id, String name, String description) async {
    await http.put(Uri.parse('$baseUrl/data.php'), body: json.encode({
      'id': id,
      'name': name,
      'description': description,
    }));
  }

  Future<void> deleteItem(int id) async {
    await http.delete(Uri.parse('$baseUrl/data.php'), body: json.encode({'id': id}));
  }
}
