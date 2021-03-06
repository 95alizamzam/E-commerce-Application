import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/filter_widget/filter_save_button.dart';
import 'package:flutter_node/Widgets/filter_widget/slider.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class filterScreen extends StatefulWidget {
  filterScreen({Key? key}) : super(key: key);

  @override
  State<filterScreen> createState() => _filterScreenState();
}

class _filterScreenState extends State<filterScreen> {
  final Map<String, dynamic> filters = {};

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        if (state is FilteredProductsEmpty) {
          showSnackBar(
            context: context,
            color: primaryColor,
            message:
                LocaleKeys.Opps_There_is_No_Products_for_Those_Filters.tr(),
            messageColor: secondaryColor,
          );
        }
        if (state is getFilteredProductsDone) {
          showSnackBar(
            context: context,
            color: primaryColor,
            message: LocaleKeys.Filtered_Products_Done_Successfully.tr(),
            messageColor: secondaryColor,
          );
          goto(
            child: homeScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        }
        if (state is FiltersCleared) {
          showSnackBar(
            context: context,
            color: primaryColor,
            message: LocaleKeys.Filtered_Products_reset_Successfully.tr(),
            messageColor: secondaryColor,
          );
        }
      },
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return SafeArea(
          bottom: true,
          top: true,
          child: WillPopScope(
            onWillPop: () async {
              goto(
                child: homeScreen(),
                type: PageTransitionType.fade,
                context: context,
              );
              return true;
            },
            child: Scaffold(
              backgroundColor: secondaryColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: secondaryColor,
                title: Text(
                  LocaleKeys.Filters.tr(),
                  style: TextStyle(color: primaryColor),
                ),
                titleSpacing: 10,
                actions: [
                  IconButton(
                      onPressed: () {
                        cubit.resetFilters();
                      },
                      icon: Icon(
                        Icons.restart_alt,
                        color: primaryColor,
                      )),
                ],
              ),
              body: ListView(
                children: [
                  filterTitle(
                    title: LocaleKeys.Filter_By_Category.tr(),
                    text: LocaleKeys.Here_You_can_Filter_products_by_Categories
                        .tr(),
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 10,
                    children: cubit.cat_Modal!.data.map((item) {
                      return wrapItem(
                          text: item.title.toString(),
                          clr: cubit.categories.contains(item.title.toString())
                              ? Colors.green
                              : secondaryColor,
                          func: () {
                            cubit.setFilters(
                              sliderValues: null,
                              title: item.title!,
                            );
                          });
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  filterTitle(
                    title: LocaleKeys.Filter_By_Price.tr(),
                    text: LocaleKeys
                            .Here_You_can_Filter_products_by_Price_Select_Min_and_Max_Price
                        .tr(),
                  ),
                  filterSlider(),
                  const SizedBox(height: 20),
                  state is getFilteredProductsLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : filterButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget filterTitle({
  required String title,
  required String text,
}) {
  return Column(children: [
    Container(
      color: primaryColor,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(color: secondaryColor),
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    )
  ]);
}

Widget wrapItem({
  required String text,
  required Function func,
  required Color clr,
}) {
  return GestureDetector(
    onTap: () {
      func();
    },
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: clr,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor)),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            color:
                secondaryColor == Colors.white ? Colors.black : Colors.white),
      ),
    ),
  );
}
