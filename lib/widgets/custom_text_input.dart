import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboarType;
  const CustomTextInput({Key? key, this.hintText, this.controller,this.keyboarType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboarType,
      style: TextStyle(color: AppColors.primaryWhite),
      decoration: InputDecoration(
        fillColor: AppColors.greyWhite,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.primaryWhite,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
