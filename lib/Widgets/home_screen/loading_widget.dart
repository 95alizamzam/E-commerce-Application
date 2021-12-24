import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:progress_indicators/progress_indicators.dart';

class loadingWidget extends StatelessWidget {
  const loadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadingText(
        LocaleKeys.Loading.tr(),
        style: TextStyle(
          fontSize: 20,
          color: primaryColor,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
