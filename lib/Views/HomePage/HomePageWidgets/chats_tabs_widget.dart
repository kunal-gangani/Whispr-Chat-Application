import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/auth_controller.dart';
import 'package:whispr_chat_application/Model/user_model.dart';
import 'package:whispr_chat_application/Routes/routes.dart';

Widget buildChatsTab() {
  final AuthController authController = Get.find<AuthController>();

  return Obx(() {
    final users = authController.filteredUsers; // Exclude the current user

    if (users.isEmpty) {
      return Center(
        child: Text(
          'No users available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      itemCount: users.length,
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) {
        final user = users[index];

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
            user.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '12:30 PM',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '2',
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
            );
          },
        );
      },
    );
  });
}
