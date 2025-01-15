import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class ItemView extends StatelessWidget {
  final ItemController _controller = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenu Administrateur!!")),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _controller.items.length,
                itemBuilder: (context, index) {
                  final item = _controller.items[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _controller.deleteItem(item.id);
                          Get.snackbar(
                            "Succès",
                            "L'utilisateur a été supprimé.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        },
                      ),
                      onTap: () {
                        _showBottomSheet(
                          context,
                          title: "Modifier utilisateur",
                          item: item,
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () =>
                  _showBottomSheet(context, title: "Ajouter un utilisateur"),
              icon: Icon(Icons.add),
              label: Container(child: Text("Nouveau")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context,
      {required String title, dynamic item}) {
    final nameController =
        TextEditingController(text: item != null ? item.name : '');
    final descController =
        TextEditingController(text: item != null ? item.description : '');
    final nameFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          nameFocusNode.requestFocus();
        });
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  focusNode: nameFocusNode,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (item == null) {
                      _controller.addItem(
                        nameController.text,
                        descController.text,
                      );
                      Get.snackbar(
                        "Succès",
                        "L'utilisateur a été ajouté.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                      );
                    } else {
                      _controller.updateItem(
                        item.id,
                        nameController.text,
                        descController.text,
                      );
                      Get.snackbar(
                        "Succès",
                        "L'utilisateur a été modifié.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item == null ? Icons.add_circle : Icons.edit, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(item == null ? "Enregistrer" : "Modifier"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
