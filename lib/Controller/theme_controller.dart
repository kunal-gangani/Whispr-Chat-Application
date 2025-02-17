import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read('isDarkMode') ?? false; 
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light,);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value,);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light,);
  }
}
