import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNewChatOptions({required Color textColor}) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.chat,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Start New Chat',
            ),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_add,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Add New Connection',
              // style: TextStyle(
              //   color: textColor,
              // ),
            ),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.smart_toy,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Chat with AI',
              // style: TextStyle(
              //   color: textColor,
              // ),
            ),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    backgroundColor: Colors.white,
  );
}
