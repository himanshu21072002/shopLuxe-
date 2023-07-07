import 'package:flutter/material.dart';

class GapWidget extends StatelessWidget {
  final double size;
  const GapWidget({Key? key, this.size=0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16+size,
      width: 16+size,
    );
  }
}
