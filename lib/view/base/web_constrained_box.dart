import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';

class WebConstrainedBox extends StatelessWidget {
  final int dataLength;
  final int minLength;
  final double minHeight;
  final child ;
  const WebConstrainedBox({Key key, @required this.dataLength, this.minLength = 5, this.minHeight = 0.6, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? dataLength < minLength ? MediaQuery.of(context).size.height * minHeight: 0.0 : 0.0),
      child: child,
    );
  }
}
