import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whispr_chat_application/MyApp/my_app.dart';
import 'package:whispr_chat_application/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}
