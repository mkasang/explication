import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/user_controller.dart';
import 'controllers/post_controller.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des contrôleurs avec GetX
    // Get.put() enregistre l'instance comme singleton
    Get.put(UserController());
    Get.put(PostController());

    return GetMaterialApp(
      // GetMaterialApp est essentiel pour GetX (navigation, snackbars, etc.)
      title: 'Flutter MVC avec GetX + API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
    );
  }
}
