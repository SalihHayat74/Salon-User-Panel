




import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;

  TextAlign? textAlign;

  ReusableText({super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign=TextAlign.start
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
