import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/task_controller.dart';
import 'screens/home_page.dart';

void main() {

  Get.put(TaskController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Topo App - Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
