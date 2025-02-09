import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Routes/routes.dart';
import 'package:whispr_chat_application/Service/auth_helper.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // ? Register Page Variables
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ? Login Page Variables
  final TextEditingController logInEmailController = TextEditingController();
  final TextEditingController logInPasswordController = TextEditingController();

  bool isLoading = false;

  User? get user => _authService.currentUser;
  bool get isAuthenticated => user != null;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> logOut() async {
    await _authService.signOut();
  }

  Future<void> registerWithEmail() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Validation Error', 'Passwords do not match',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
      return;
    }
    setLoading(true);
    try {
      await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      clearFields();
      Get.toNamed(Routes.loginPage);
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: $e',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithEmail() async {
    setLoading(true);
    try {
      await _authService
          .signInWithEmail(
        email: logInEmailController.text.trim(),
        password: logInPasswordController.text.trim(),
      )
          .then((value) {
        Get.offNamed(Routes.homePage);
      });
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
      await _authService.signInWithGoogle();
      Get.snackbar('Success', 'Google sign-in successful',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900);
    } catch (e) {
      Get.snackbar('Error', 'Google sign-in failed: $e',
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.toNamed(Routes.loginPage);
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    logInEmailController.clear();
    logInPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    logInEmailController.dispose();
    logInPasswordController.dispose();
    super.onClose();
  }
}
