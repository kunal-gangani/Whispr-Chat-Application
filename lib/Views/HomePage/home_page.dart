import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/build_ai_chat_tab_widget.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/chats_tabs_widget.dart';
import 'package:whispr_chat_application/Views/HomePage/HomePageWidgets/show_new_chats_options_widget.dart';
import 'package:whispr_chat_application/Widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        Get.put<AuthController>(AuthController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Whispr Chat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
              ),
              onPressed: () => authController.logOut(),
            ),
          ],
          bottom: const CustomTabBar(),
        ),
        drawer: Drawer(
          backgroundColor: Colors.blue.shade50,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                accountName: Obx(() {
                  final userName =
                      authController.userModel.value?.name ?? 'User';
                  return Text(
                    userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                accountEmail: Obx(() {
                  final userEmail = authController.userModel.value?.email ?? '';
                  return Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  );
                }),
              ),
              _buildDrawerItem(
                Icons.person,
                "Profile",
                () {},
              ),
              _buildDrawerItem(
                Icons.settings,
                "Settings",
                () {},
              ),
              const Divider(),
              _buildDrawerItem(
                Icons.help,
                "Help & Feedback",
                () {},
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildChatsTab(),
            buildAIChatTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showNewChatOptions(
              textColor: Colors.white, // Set default color
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blueAccent,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
