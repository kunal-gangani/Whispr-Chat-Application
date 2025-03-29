import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/chat_controller.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Model/user_model.dart';

class ChatWithUserPage extends StatelessWidget {
  final UserModel user;
  final ChatController chatController = Get.put(ChatController());
  final AuthController authController = Get.find<AuthController>();

  ChatWithUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentUserId = authController.currentUserId.value;
    if (currentUserId == null) {
      return _buildErrorScreen("User not logged in");
    }

    // Initialize chat when widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.initializeChat(currentUserId, user.id);
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMessagesList(currentUserId),
          _buildMessageInput(currentUserId),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      body: Center(
        child: Text(
          "Error: $error",
          style: TextStyle(fontSize: 16.sp, color: Colors.red),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.grey.shade300,
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
          Text(
            user.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(String currentUserId) {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          reverse: true,
          itemCount: chatController.messages.length,
          itemBuilder: (context, index) {
            final message = chatController.messages[index];
            return _buildMessageBubble(message, currentUserId);
          },
        );
      }),
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> message, String currentUserId) {
    final isMe = message['senderId'] == currentUserId;
    final timestamp = message['timestamp'] as Timestamp?;
    final timeText = timestamp != null
        ? '${timestamp.toDate().hour}:${timestamp.toDate().minute.toString().padLeft(2, '0')}'
        : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        padding: EdgeInsets.all(10.r),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text']?.toString() ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 3.h),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeText,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMe ? Colors.white54 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(String currentUserId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
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
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () => chatController.sendMessage(currentUserId),
          ),
        ],
      ),
    );
  }
}
