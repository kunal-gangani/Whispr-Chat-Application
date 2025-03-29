import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Controller/chat_controller.dart';
import 'package:whispr_chat_application/Routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      minTextAdapt: true,
      builder: (context, _) {
        return GetMaterialApp(
          initialBinding: BindingsBuilder(() {
            Get.put(
              AuthController(),
            );
            Get.put(
              ChatController(),
            );
          }),
          debugShowCheckedModeBanner: false,
          getPages: Routes.myRoutes,
        );
      },
    );
  }
}
