import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

class AuthFooter extends StatelessWidget {
  final String? title;
  final String? screenName;
  final Function()? onPressed;
  const AuthFooter({Key? key, this.title, this.screenName, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white24,
                fontSize: 16,
              ),
            ),
            TextSpan(
                text: ' $screenName',
                style: TextStyle(
                  color: AppColors.btnColor,
                  fontSize: 18,
                )),
          ],
        ),
      ),
    );
  }
}
