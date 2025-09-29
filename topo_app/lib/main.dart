import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToPo App',
      home: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 100)),
        builder: (context, snapshot) {
          final authController = Get.find<AuthController>();
          return Obx(() {
            if (authController.isLoading.value) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return authController.user.value != null
                ? _createHomePage()
                : LoginPage();
          });
        },
      ),
    );
  }

  Widget _createHomePage() {
    if (!Get.isRegistered<TaskController>()) {
      Get.put(TaskController());
    } else {
      final taskController = Get.find<TaskController>();
      taskController.loadTasks();
    }
    return HomePage();
  }
}
