import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_with_me/core/ui.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  const PrimaryButton({Key? key, required this.text,this.onPressed, this.color, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CupertinoButton(
        color: color??AppColors.accent,
        onPressed: onPressed,
        child: Text(text,style: textStyle,),
      ),
    );
  }
}
