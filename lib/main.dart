import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Crud App Avec GetX",
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(        
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,          
        ),
       
      ),
      darkTheme: ThemeData.dark(), 
      themeMode: ThemeMode.system, 
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
