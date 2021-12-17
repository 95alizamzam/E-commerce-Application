import 'package:flutter/material.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';

class intro extends StatelessWidget {
  const intro({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      color: secondaryColor,
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
