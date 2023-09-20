import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  const PrimaryButton({Key? key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onPressed ?? () {},
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.btnColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
