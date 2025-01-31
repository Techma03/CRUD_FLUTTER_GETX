
import 'package:crudapp/app/modules/agents/model/agents_model.dart';
import 'package:crudapp/app/data/api_provider.dart';
import 'package:get/get.dart';

class CrudController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var agent = <Agent>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAgent();
  }

  void fetchAgent() async {
    final response = await _apiProvider.getAgent();
    agent.value = response.map((data) => Agent.fromJson(data)).toList();
  }

  void addAgent(String name, String description) async {
    final Map<String, dynamic>? newAgent =
        await _apiProvider.addAgent(name, description);
    if (newAgent != null) {
      agent.add(Agent.fromJson(newAgent));           
    } 
    fetchAgent();
  }

  void updateAgent(int id, String name, String description) async {
    final updatedAgent = await _apiProvider.updateAgent(id, name, description);
    final index = agent.indexWhere((u) => u.id == id);
    if (index != -1) {
      agent[index] = Agent.fromJson(updatedAgent!);
    }     
     fetchAgent();
  }

  void deleteAgent(int id) async {
    final success = await _apiProvider.deleteAgent(id);
    if (success) {
      agent.removeWhere((u) => u.id == id);
    }
    fetchAgent();
  }
}
