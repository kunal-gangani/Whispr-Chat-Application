import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildChatsTab() {
  return ListView.separated(
    itemCount: 10,
    separatorBuilder: (context, index) => Divider(
      thickness: 1,
      color: Colors.grey.shade300,
    ),
    itemBuilder: (context, index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.2),
          child: Text(
            'JD',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'John Doe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last message goes here...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
            SizedBox(
              height: 5.h,
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        onTap: () {},
      );
    },
  );
}
