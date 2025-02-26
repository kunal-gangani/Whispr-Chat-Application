import 'package:get/get.dart';
import 'package:whispr_chat_application/Views/HomePage/home_page.dart';
import 'package:whispr_chat_application/Views/LoginPage/login_page.dart';
import 'package:whispr_chat_application/Views/RegisterPage/register_page.dart';
import 'package:whispr_chat_application/Views/SplashScreen/splash_screen.dart';

class Routes {
  static String splashScreen = '/';
  static String loginPage = '/login';
  static String registerPage = '/register';
  static String homePage = '/home';

  static List<GetPage> myRoutes = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: loginPage,
      page: () => LoginPage(),
    ),
    GetPage(
      name: registerPage,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: homePage,
      page: () => HomePage(),
    ),
  ];
}
