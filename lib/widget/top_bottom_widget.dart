import 'package:flutter/material.dart';

import '../res/styles.dart';

class TopBottom extends StatelessWidget {
  final Widget top;
  final Widget bottom;
  final double margin;

  TopBottom({
    required this.top,
    required this.bottom,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        top,
        SizeBoxFactory.getVerticalSizeBox(margin),
        bottom
      ],
    );
  }
}
