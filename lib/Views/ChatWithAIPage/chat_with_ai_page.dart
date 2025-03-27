import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:whispr_chat_application/Controller/chat_with_ai_controller.dart';

class ChatWithAIPage extends StatelessWidget {
  ChatWithAIPage({super.key});

  final ChatWithAiController chatController = Get.put(ChatWithAiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: const Text(
          "AI Assistant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          child: Column(
            children: [
              // Search Bar
              Card(
                color: Colors.blue.shade100,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    onChanged: (query) {
                      chatController.setSearchQuery(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      hintStyle: TextStyle(
                        color: Colors.blueGrey.shade700,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () => chatController.setSearchQuery(''),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              // Message List
              Expanded(
                child: GetBuilder<ChatWithAiController>(
                  builder: (controller) {
                    return controller.filteredMessages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 80.sp,
                                  color: Colors.blueGrey.shade400,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "Start a conversation with Gemini-AI",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      fontSize: 18.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.filteredMessages.length +
                                (controller.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (controller.isLoading &&
                                  index == controller.filteredMessages.length) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade200,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: SizedBox(
                                      width: 50.w, // Restrict width
                                      child: SpinKitThreeBounce(
                                        color: Colors.blueAccent,
                                        size: 18.0.sp, // Reduce size
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final message =
                                  controller.filteredMessages[index];
                              return Column(
                                children: [
                                  if (message.containsKey('question'))
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0.r),
                                            topRight: Radius.circular(15.0.r),
                                            bottomLeft: Radius.circular(15.0.r),
                                          ),
                                        ),
                                        child: Text(
                                          message['question']?.toString() ??
                                              '...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  if (message.containsKey('answer'))
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0.r),
                                            topRight: Radius.circular(15.0.r),
                                            bottomRight:
                                                Radius.circular(15.0.r),
                                          ),
                                        ),
                                        child: Text(
                                          message['answer']?.toString() ??
                                              '...',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                  },
                ),
              ),

              // Input Field
              Card(
                color: Colors.blue.shade100,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: chatController.messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            hintStyle:
                                TextStyle(color: Colors.blueGrey.shade700),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blueAccent),
                        onPressed: () {
                          chatController.searchQuery();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
