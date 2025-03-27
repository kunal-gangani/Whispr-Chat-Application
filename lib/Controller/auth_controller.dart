import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Model/user_model.dart';
import 'package:whispr_chat_application/Routes/routes.dart';
import 'package:whispr_chat_application/Service/auth_helper.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController logInEmailController = TextEditingController();
  final TextEditingController logInPasswordController = TextEditingController();

  var isLoading = false.obs;
  var userModel = Rxn<UserModel>();

  User? get user => _authService.currentUser;
  bool get isAuthenticated => user != null;

  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxString currentUserId = ''.obs;

  void setUsers(List<UserModel> users) {
    allUsers.assignAll(users);
  }

  void setCurrentUserId(String id) {
    currentUserId.value = id;
  }

  @override
  void onInit() {
    super.onInit();
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Users').get();
      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      setUsers(users);
      if (user != null) {
        setCurrentUserId(user!.uid);
      }
    } catch (e) {
      log("Error loading users: $e");
    }
  }

  List<UserModel> get filteredUsers =>
      allUsers.where((user) => user.id != currentUserId.value).toList();

  void setLoading(bool value) => isLoading.value = value;

  /// Load user data from Firestore
  Future<void> loadUserData() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user!.uid).get();
      if (userDoc.exists) {
        userModel.value =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      log("Error loading user data: $e");
    }
  }

  /// Register with email & password
  Future<void> registerWithEmail() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Validation Error', 'Passwords do not match',
          backgroundColor: Colors.red.shade100);
      return;
    }

    setLoading(true);
    try {
      UserCredential userCredential = await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email!,
          profilePictureUrl: userCredential.user!.photoURL ?? '',
        );

        await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());
        userModel.value = newUser;
      }

      clearFields();
      Get.offAllNamed(Routes.homePage);
    } catch (e) {
      log("Registration Error: $e");
      Get.snackbar('Error', 'Registration failed: $e',
          backgroundColor: Colors.red.shade100);
    } finally {
      setLoading(false);
    }
  }

  /// Sign in with email & password
  Future<void> signInWithEmail() async {
    setLoading(true);
    try {
      UserCredential userCredential = await _authService.signInWithEmail(
        email: logInEmailController.text.trim(),
        password: logInPasswordController.text.trim(),
      );

      await loadUserData();
      Get.offAllNamed(Routes.homePage);
    } catch (e) {
      log("Login Error: $e");
      Get.snackbar('Error', 'Login failed: $e',
          backgroundColor: Colors.red.shade100);
    } finally {
      setLoading(false);
    }
  }

  /// Google Sign-In
  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
      UserCredential userCredential = await _authService.signInWithGoogle();

      if (userCredential.user != null) {
        await loadUserData();
      }

      Get.offAllNamed(Routes.homePage);
    } catch (e) {
      log("Google Sign-In Error: $e");
      Get.snackbar("Error", "Google sign-in failed.");
    } finally {
      setLoading(false);
    }
  }

  /// Reset Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: Colors.red.shade100);
      return;
    }

    setLoading(true);
    try {
      await _authService.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent',
          backgroundColor: Colors.green.shade100);
    } catch (e) {
      log("Password Reset Error: $e");
      Get.snackbar('Error', 'Failed to send reset email: $e',
          backgroundColor: Colors.red.shade100);
    } finally {
      setLoading(false);
    }
  }

  /// Log out user
  Future<void> logOut() async {
    await _authService.signOut();
    userModel.value = null;
    Get.offAllNamed(Routes.loginPage);
  }

  /// Clear input fields
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
