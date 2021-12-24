import 'package:flutter/material.dart';
import 'package:flutter_node/Widgets/register_screen/form_section.dart';
import 'package:flutter_node/Widgets/register_screen/top_section.dart';

import 'package:flutter_node/shared/styles.dart';

class registerScreen extends StatelessWidget {
  registerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: secondaryColor,
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    topSection(),
                    registerFrom(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
