import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whispr_chat_application/MyApp/my_app.dart';
import 'package:whispr_chat_application/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}
