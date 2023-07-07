import 'package:flutter/cupertino.dart';
import 'package:shop_with_me/core/ui.dart';

class LinkButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  const LinkButton({Key? key, required this.text, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? AppColors.accent,
        ),
      ),
    );
  }
}
