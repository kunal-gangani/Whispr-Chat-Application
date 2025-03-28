import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Model/user_model.dart';

class ChatWithUserPage extends StatelessWidget {
  final UserModel user;

  const ChatWithUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final List<Map<String, dynamic>> messages = [
      {"text": "Hey!", "isMe": false, "time": "10:15 AM"},
      {"text": "Hello! How are you?", "isMe": true, "time": "10:16 AM"},
      {"text": "I'm doing great, thanks!", "isMe": false, "time": "10:18 AM"},
      {
        "text": "Awesome! Let's catch up later.",
        "isMe": true,
        "time": "10:20 AM"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
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
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message["isMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: message["isMe"]
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                        bottomLeft: message["isMe"]
                            ? Radius.circular(12.r)
                            : Radius.zero,
                        bottomRight: message["isMe"]
                            ? Radius.zero
                            : Radius.circular(12.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["text"],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                message["isMe"] ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            message["time"],
                            style: TextStyle(
                              fontSize: 10.sp,
                              color:
                                  message["isMe"] ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            BorderRadius.circular(25.r), // Rounded edges
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.trim().isNotEmpty) {
                        // TODO: Send message logic here
                        messageController.clear();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: messageController.text.trim().isNotEmpty
                            ? Colors.blueAccent
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
