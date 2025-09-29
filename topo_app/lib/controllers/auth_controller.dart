import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topo_app/controllers/task_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rxn<User>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (user.value != null) {
          isLoading.value = false;
          return;
        }
      }
    } catch (e) {
      print('Auto-login error: $e');
    }
    isLoading.value = false;
  }

  Future<void> _saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveLoginStatus(true);
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveLoginStatus(true);
    } catch (e) {
      Get.snackbar('Registration Error', e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    if (Get.isRegistered<TaskController>()) {
      Get.find<TaskController>().clearTasks();
    }

    await _saveLoginStatus(false);
    await _auth.signOut();
  }
}
