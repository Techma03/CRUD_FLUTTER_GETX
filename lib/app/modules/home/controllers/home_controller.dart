import 'package:crudapp/app/data/api_provider_provider.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class ItemController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  var items = <Item>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  void fetchItems() async {
    final response = await _apiProvider.getItems();
    items.value = response.map((data) => Item.fromJson(data)).toList();
  }

  void addItem(String name, String description) async {
    await _apiProvider.addItem(name, description);
    fetchItems();
  }

  void updateItem(int id, String name, String description) async {
    await _apiProvider.updateItem(id, name, description);
    fetchItems();
  }

  void deleteItem(int id) async {
    await _apiProvider.deleteItem(id);
    fetchItems();
  }
}
