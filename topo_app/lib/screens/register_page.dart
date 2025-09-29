import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/input_field.dart';
import '../widgets/password_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _controllers = _RegistrationControllers();
  final AuthController _authController = Get.find<AuthController>();
  bool _isLoading = false;

  String? _validateForm() {
    if (_controllers.name.text.trim().isEmpty) {
      return "Please enter your name";
    }
    if (_controllers.email.text.trim().isEmpty) {
      return "Please enter your email";
    }
    if (_controllers.password.text.isEmpty) {
      return "Please enter your password";
    }
    if (_controllers.confirmPassword.text.isEmpty) {
      return "Please confirm your password";
    }
    if (_controllers.password.text != _controllers.confirmPassword.text) {
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> _register() async {
    final error = _validateForm();
    if (error != null) {
      Get.snackbar("Error", error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authController.register(
        _controllers.email.text.trim(),
        _controllers.password.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      Get.put(TaskController());
      Get.offAll(() => HomePage());
    } catch (error) {
      Get.snackbar("Error", error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Create your account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildFormFields(),
            const SizedBox(height: 30),
            AuthButton(
              text: "Create Account",
              onPressed: _register,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Already have an account? Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        InputField(
          controller: _controllers.name,
          labelText: "Full Name",
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: _controllers.email,
          labelText: "Email",
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        PasswordField(controller: _controllers.password, labelText: "Password"),
        const SizedBox(height: 16),
        PasswordField(
          controller: _controllers.confirmPassword,
          labelText: "Confirm Password",
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }
}

class _RegistrationControllers {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }
}
