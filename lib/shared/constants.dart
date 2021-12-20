import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void goto({
  required Widget child,
  required PageTransitionType type,
  required BuildContext context,
}) {
  Navigator.of(context).pushReplacement(PageTransition(
      child: child, type: type, duration: const Duration(milliseconds: 600)));
}

String basicUrl = 'http://192.168.1.3:3000';
String userToken = '';
int tokenDate = 0;
