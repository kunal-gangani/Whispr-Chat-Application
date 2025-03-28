import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Model/user_model.dart';
import 'package:whispr_chat_application/Views/ChatWithAIPage/chat_with_ai_page.dart';
import 'package:whispr_chat_application/Views/ChatWithUserPage/chat_with_user_page.dart';
import 'package:whispr_chat_application/Views/HomePage/home_page.dart';
import 'package:whispr_chat_application/Views/LoginPage/login_page.dart';
import 'package:whispr_chat_application/Views/RegisterPage/register_page.dart';
import 'package:whispr_chat_application/Views/SplashScreen/splash_screen.dart';

class Routes {
  static String splashScreen = '/';
  static String loginPage = '/login';
  static String registerPage = '/register';
  static String homePage = '/home';
  static String aiChatPage = '/aichat';
  static String userChatPage = '/userchat';

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
    GetPage(
      name: aiChatPage,
      page: () => ChatWithAIPage(),
    ),
    GetPage(
      name: userChatPage,
      page: () => ChatWithUserPage(
        user: UserModel(
          id: 1.toString(),
          name: "Kunal",
          email: "thekunalgangani@gmail.com",
        ),
      ),
    ),
  ];
}
