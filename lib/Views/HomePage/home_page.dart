import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Controller/theme_controller.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/build_ai_chat_tab_widget.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/build_connections_widget.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/chats_tabs_widget.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/show_new_chats_options_widget.dart';
import 'package:whispr_chat_application/Widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.put<ThemeController>(
      ThemeController(),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Whispr Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () => authController.logOut(),
            ),
          ],
          bottom: CustomTabBar(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                accountName: Text(
                  authController.user?.displayName ?? 'User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  authController.user?.email ?? '',
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                ),
                title: Text(
                  'Profile',
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                ),
                title: Text(
                  'Settings',
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  themeController.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: Text(
                  'Theme',
                ),
                onTap: () => themeController.toggleTheme(),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.help,
                ),
                title: Text(
                  'Help & Feedback',
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Chats Tab
            buildChatsTab(),
            // Connections Tab
            buildConnectionsTab(),
            // AI Chat Tab
            buildAIChatTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showNewChatOptions();
          },
        ),
      ),
    );
  }
}
