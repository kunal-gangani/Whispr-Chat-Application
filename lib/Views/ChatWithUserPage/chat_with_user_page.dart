import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Controller/chat_controller.dart';
import 'package:whispr_chat_application/Model/user_model.dart';
import 'package:whispr_chat_application/Routes/routes.dart';

class ChatWithUserPage extends StatelessWidget {
  final UserModel user;

  const ChatWithUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final authController = Get.find<AuthController>();

    // Initialize chat when authenticated
    if (authController.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatController.initializeChat(user.id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: user.profilePictureUrl.isNotEmpty
                  ? NetworkImage(user.profilePictureUrl)
                  : null,
              child: user.profilePictureUrl.isEmpty
                  ? Text(
                      user.initials,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    )
                  : null,
            ),
            SizedBox(width: 10.w),
            Text(user.name,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          ],
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: _buildBody(chatController, authController),
    );
  }

  Widget _buildBody(
      ChatController chatController, AuthController authController) {
    // Use GetX for the authentication state
    return GetX<AuthController>(
      builder: (authController) {
        if (!authController.isAuthenticated) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Please login to continue chatting',
                    style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.loginPage),
                  child: Text('Go to Login'),
                ),
              ],
            ),
          );
        }

        // Use Obx for chat-specific reactive updates
        return Column(
          children: [
            Expanded(
              child: Obx(() => _buildMessagesList(chatController)),
            ),
            Obx(() => _buildMessageInput(chatController)),
          ],
        );
      },
    );
  }

  Widget _buildMessagesList(ChatController chatController) {
    if (chatController.messages.isEmpty) {
      return Center(child: Text('No messages yet'));
    }

    return ListView.builder(
      controller: ScrollController(),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      reverse: true,
      itemCount: chatController.messages.length,
      itemBuilder: (context, index) {
        final message = chatController.messages[index];
        final isMe = message['senderId'] == chatController.currentUserId.value;
        final timestamp = message['timestamp'] as Timestamp?;
        final timeText = timestamp != null
            ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
            : '';

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            padding: EdgeInsets.all(12.r),
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: isMe ? Radius.circular(12.r) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(12.r),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message['text']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  timeText,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: isMe ? Colors.white70 : Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(ChatController chatController) {
    if (chatController.currentUserId.value.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatController.messageController,
              focusNode: chatController.messageFocusNode,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.blueAccent,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: chatController.isLoading.value
                      ? null
                      : () => chatController.sendMessage(user.id),
                ),
              )),
        ],
      ),
    );
  }
}
