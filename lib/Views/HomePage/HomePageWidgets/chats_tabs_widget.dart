import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Controller/chat_controller.dart';
import 'package:whispr_chat_application/Routes/routes.dart';

Widget buildChatsTab() {
  final AuthController authController = Get.find<AuthController>();
  final ChatController chatController =
      Get.put<ChatController>(ChatController());

  return Obx(() {
    final users = authController.filteredUsers;

    if (users.isEmpty) {
      return Center(
        child: Text(
          'No users available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey,),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w,),
      itemCount: users.length,
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) {
        final user = users[index];
        final lastMessage = chatController.getLastMessage(user.id);
        final unreadCount = chatController.getUnreadMessageCount(user.id);

        return ListTile(
          leading: CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            backgroundImage: user.profilePictureUrl.isNotEmpty
                ? NetworkImage(user.profilePictureUrl)
                : null,
            child: user.profilePictureUrl.isEmpty
                ? Text(
                    user.initials,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  )
                : null,
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          subtitle: Text(
            lastMessage ?? 'No messages yet',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600,),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chatController.getLastMessageTime(user.id) ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              if (unreadCount > 0) SizedBox(height: 5.h),
              if (unreadCount > 0)
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () {
            Get.toNamed(
              Routes.userChatPage,
              arguments: user,
            );
          },
        );
      },
    );
  });
}
