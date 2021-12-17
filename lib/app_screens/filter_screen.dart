import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'Opps, There is No Products for Those Filters !!',
              style: TextStyle(color: secondaryColor),
            ),
          ));
        }

        if (state is getFilteredProductsDone) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'Filtered Products Done Successfully',
              style: TextStyle(color: secondaryColor),
            ),
          ));

          goto(
            child: homeScreen(),
            type: PageTransitionType.fade,
            context: context,
          );
        }
        if (state is FiltersCleared) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'Filtered Products reset Successfully',
              style: TextStyle(color: secondaryColor),
            ),
          ));
        }
      },
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return SafeArea(
          bottom: true,
          top: true,
          child: Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: secondaryColor,
              title: Text(
                'Filters',
                style: TextStyle(color: primaryColor),
              ),
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () {
                    goto(
                      child: homeScreen(),
                      type: PageTransitionType.fade,
                      context: context,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: primaryColor,
                  )),
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
                filterTitle(title: 'Filter By Category'),
                filterIntro(
                    text: 'Here You can Filter products by Categories  :'),
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
                            if (cubit.categories.contains(item.title)) {
                              setState(() {
                                cubit.categories
                                    .remove(item.title.toString().trim());
                              });
                            } else {
                              setState(() {
                                cubit.categories
                                    .add(item.title.toString().trim());
                              });
                            }
                          });
                    }).toList()),
                const SizedBox(height: 20),
                filterTitle(title: 'Filter By Price'),
                filterIntro(
                    text:
                        'Here You can Filter products by Price , Select Min and Max Price  :'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Min:',
                        style: TextStyle(color: primaryColor),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: primaryColor,
                          label: cubit.minPriceValue.toString(),
                          value: cubit.minPriceValue,
                          onChanged: (double val) {
                            setState(() {
                              cubit.minPriceValue = val;
                            });
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                        ),
                      ),
                      Text(
                        cubit.minPriceValue.toString() + "\$",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Max:',
                        style: TextStyle(color: primaryColor),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: primaryColor,
                          label: cubit.maxPriceValue.toString(),
                          value: cubit.maxPriceValue,
                          onChanged: (double val) {
                            setState(() {
                              cubit.maxPriceValue = val;
                            });
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                        ),
                      ),
                      Text(
                        cubit.maxPriceValue.toString() + '\$',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                state is getFilteredProductsLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          cubit.getFilteredProducts(
                            selectedPrice: cubit.maxPriceValue,
                            minPriceValue: cubit.minPriceValue,
                            selectedCategories: cubit.categories,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                            border: Border.all(color: secondaryColor),
                          ),
                          child: Text('Save Changes',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                              )),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget filterTitle({
  required String title,
}) {
  return Container(
    color: primaryColor,
    margin: const EdgeInsets.only(bottom: 10, top: 10),
    padding: const EdgeInsets.all(16),
    alignment: Alignment.center,
    width: double.infinity,
    child: Text(
      title,
      style: TextStyle(color: secondaryColor),
    ),
  );
}

Widget filterIntro({
  required String text,
}) {
  return Padding(
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
  );
}

Widget wrapItem(
    {required String text, required Function func, required Color clr}) {
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
