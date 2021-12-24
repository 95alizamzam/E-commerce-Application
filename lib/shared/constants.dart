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

void showSnackBar({
  required BuildContext context,
  required Color color,
  required String message,
  required Color messageColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 1),
    elevation: 4,
    backgroundColor: color,
    content: Text(
      message,
      style: TextStyle(
        fontSize: 18,
        color: messageColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  ));
}

String basicUrl = 'http://192.168.1.8:3000';
String userToken = '';
int tokenDate = 0;
