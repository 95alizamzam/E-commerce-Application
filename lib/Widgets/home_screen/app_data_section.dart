import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node/Widgets/home_screen/carousel_widget.dart';
import 'package:flutter_node/Widgets/home_screen/categories_show.dart';
import 'package:flutter_node/Widgets/home_screen/introduction.dart';
import 'package:flutter_node/Widgets/home_screen/products_widget.dart';
import 'package:flutter_node/translations/local_keys.dart';

class appDataSection extends StatelessWidget {
  const appDataSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            carouselWidget(),
            intro(title: LocaleKeys.Categories.tr()),
            categoriesShow(),
            productsWidget(),
          ],
        ),
      ),
    );
  }
}
