import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildAIChatTab() {
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
        SizedBox(
          height: 24.h,
        ),
        Text(
          'Chat with AI Assistant',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Text(
          'Get instant answers to your questions',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 32.h,
        ),
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
