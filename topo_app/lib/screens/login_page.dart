import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';
import '../widgets/input_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      await _authController.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (_authController.user.value != null) {
        Get.put(TaskController());
        Get.offAll(() => HomePage());
      }
    } catch (error) {
      Get.snackbar("Error", error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateForm() {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return false;
    }

    if (_passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter your password");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              InputField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              PasswordField(
                controller: _passwordController,
                labelText: "Password",
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 30),

              AuthButton(
                text: "Login",
                onPressed: _login,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Get.to(() => RegisterPage()),
                  child: const Text("Don't have an account? Create one"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
