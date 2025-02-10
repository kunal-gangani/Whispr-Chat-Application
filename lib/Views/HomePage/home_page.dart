import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Widgets/custom_tab_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

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
              icon: Icon(Icons.logout),
              onPressed: () {
                authController.logOut();
              },
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
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  // Navigate to profile
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Theme'),
                onTap: () {
                  // Toggle theme
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Feedback'),
                onTap: () {
                  // Show help/feedback
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Chats Tab
            _buildChatsTab(),

            // Connections Tab
            _buildConnectionsTab(),

            // AI Chat Tab
            _buildAIChatTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            // Show options to start new chat or add connection
            _showNewChatOptions(context);
          },
        ),
      ),
    );
  }

  Widget _buildChatsTab() {
    return ListView.builder(
      itemCount: 10, // Replace with actual chat list length
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            child: Text(
              'JD', // Replace with actual initials
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            'John Doe', // Replace with actual name
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Last message goes here...', // Replace with actual last message
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '12:30 PM', // Replace with actual time
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '2', // Replace with actual unread count
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            // Navigate to chat detail
          },
        );
      },
    );
  }

  Widget _buildConnectionsTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 10, // Replace with actual connections count
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                child: Text(
                  'JD', // Replace with actual initials
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'John Doe', // Replace with actual name
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Online', // Replace with actual status
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Start chat with connection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIChatTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy,
            size: 80,
            color: Colors.blueAccent,
          ),
          SizedBox(height: 24),
          Text(
            'Chat with AI Assistant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Get instant answers to your questions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Start AI chat
            },
            icon: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            label: Text(
              'Start Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.chat,
                  color: Colors.blueAccent,
                ),
                title: Text('Start New Chat'),
                onTap: () {
                  // Navigate to new chat
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person_add,
                  color: Colors.blueAccent,
                ),
                title: Text('Add New Connection'),
                onTap: () {
                  // Navigate to add connection
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.smart_toy,
                  color: Colors.blueAccent,
                ),
                title: Text('Chat with AI'),
                onTap: () {
                  // Navigate to AI chat
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
