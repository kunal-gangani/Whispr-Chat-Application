import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget authTextField({
  required String label,
  required String hint,
  required TextEditingController controller,
  Icon? prefixIcon,
  bool isPassword = false,
  String? Function(String?)? validator,
  TextInputAction? textInputAction,
  TextInputType? keyboardType,
  bool isEnabled = true,
  VoidCallback? onTap,
  void Function(String)? onChanged,
  void Function(String)? onSubmitted,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          enabled: isEnabled,
          keyboardType: keyboardType,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return "$label is required";
                }
                return null;
              },
          textInputAction: textInputAction ?? TextInputAction.next,
          onTap: onTap,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            filled: true,
            fillColor: isEnabled ? Colors.white : Colors.grey.shade100,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blue.shade400,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 16.h,
      ),
    ],
  );
}
