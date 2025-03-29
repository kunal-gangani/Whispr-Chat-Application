import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Model/user_model.dart';
import 'package:whispr_chat_application/Routes/routes.dart';
import 'package:whispr_chat_application/Service/auth_helper.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController logInEmailController = TextEditingController();
  final TextEditingController logInPasswordController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var userModel = Rxn<UserModel>();
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxString currentUserId = ''.obs;

  // Getters
  User? get user => _authService.currentUser;
  bool get isAuthenticated => user != null;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthChanges();
    _listenToUsers();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        currentUserId.value = user.uid;
        loadUserData();
      } else {
        currentUserId.value = '';
        userModel.value = null;
      }
    });
  }

  void _listenToUsers() {
    _authService.getAllUsersStream().listen((List<UserModel> userList) {
      allUsers.assignAll(userList);
    }, onError: (error) {
      log("Error fetching users: $error");
    });
  }

  List<UserModel> get filteredUsers =>
      allUsers.where((user) => user.id != currentUserId.value).toList();

  Future<void> loadUserData() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user!.uid).get();

      if (userDoc.exists) {
        userModel.value = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>,
          docId: userDoc.id,
        );
        currentUserId.value = user!.uid;
      }
    } catch (e) {
      log("Error loading user data: $e");
    }
  }

  Future<void> registerWithEmail() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      UserCredential userCredential = await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ??
              emailController.text.split('@')[0],
          email: userCredential.user!.email!,
          profilePictureUrl: userCredential.user!.photoURL ?? '',
        );

        await _firestore
            .collection('Users')
            .doc(newUser.id)
            .set(newUser.toJson());
        userModel.value = newUser;
        Get.offAllNamed(Routes.homePage);
      }
    } catch (e) {
      log("Registration Error: $e");
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
    } finally {
      clearFields();
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail() async {
    isLoading.value = true;
    try {
      await _authService.signInWithEmail(
        email: logInEmailController.text.trim(),
        password: logInPasswordController.text.trim(),
      );
      Get.offAllNamed(Routes.homePage);
    } catch (e) {
      log("Login Error: $e");
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      clearFields();
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await _authService.signInWithGoogle();

      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          final newUser = UserModel(
            id: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email!,
            profilePictureUrl: userCredential.user!.photoURL ?? '',
          );
          await _firestore
              .collection('Users')
              .doc(newUser.id)
              .set(newUser.toJson());
        }

        Get.offAllNamed(Routes.homePage);
      }
    } catch (e) {
      log("Google Sign-In Error: $e");
      Get.snackbar('Error', 'Google sign-in failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent');
    } catch (e) {
      log("Password Reset Error: $e");
      Get.snackbar('Error', 'Failed to send reset email');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(Routes.loginPage);
    } catch (e) {
      log("Logout Error: $e");
      Get.snackbar('Error', 'Logout failed');
    }
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
