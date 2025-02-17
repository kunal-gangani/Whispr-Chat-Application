import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Routes/routes.dart';
import 'package:whispr_chat_application/Widgets/auth_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 12.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    height: 120.h,
                    width: 120.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add,
                      size: 60.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sign up to get started',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Card(
                  color: Colors.blue.shade100,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          label: "Email",
                          hint: "Enter your email",
                          controller: authController.emailController,
                          prefixIcon: Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        AuthTextField(
                          label: 'Password',
                          hint: "Enter your password",
                          controller: authController.passwordController,
                          prefixIcon: Icon(Icons.lock_outlined),
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        AuthTextField(
                          label: "Confirm Password",
                          hint: "Confirm your password",
                          controller: authController.confirmPasswordController,
                          prefixIcon: Icon(Icons.lock_outlined),
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value !=
                                authController.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        GetBuilder<AuthController>(
                          builder: (controller) => ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      controller.registerWithEmail();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: controller.isLoading
                                ? SizedBox(
                                    height: 16.h,
                                    width: 16.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        GetBuilder<AuthController>(
                          builder: (controller) => OutlinedButton.icon(
                            onPressed: controller.isLoading
                                ? null
                                : controller.signInWithGoogle,
                            icon: FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.blue,
                            ),
                            label: Text(
                              'Sign up with Google',
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              side: BorderSide(
                                color: Colors.blueAccent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: authController.isLoading
                          ? null
                          : () => Get.toNamed(
                                Routes.loginPage,
                              ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
