import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste des détails pour chaque carte
    final List<Map<String, dynamic>> cardDetails = [
      {
        'title': 'CRUD APP',
        'color': Colors.blueAccent,
        'icon': Icons.app_registration,
        'route': '/crud', // Route pour CRUD APP
      },
      {
        'title': 'TODO APP',
        'color': Colors.greenAccent,
        'icon': Icons.check_circle_outline,
        'route': '/todo', // Route pour TODO APP
      },
      {
        'title': 'PAY APP',
        'color': Colors.orangeAccent,
        'icon': Icons.payment,
        'route': '/payapp', // Route pour PAY APP
      },
      {
        'title': 'CREDIT APP',
        'color': Colors.purpleAccent,
        'icon': Icons.credit_card,
        'route': '/creditapp', // Route pour CREDIT APP
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("MULTI APPS"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux cartes par ligne
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 3 / 2, // Ratio largeur/hauteur
          ),
          itemCount: cardDetails.length,
          itemBuilder: (context, index) {
            final card = cardDetails[index];
            return Card(
              color: card['color'],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Navigue vers la route spécifiée
                  Get.toNamed(card['route']);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      card['icon'],
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      card['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
