import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class searchScreen extends StatelessWidget {
  searchScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        if (state is clearSearchedProducts) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: secondaryColor,
              duration: Duration(milliseconds: 600),
              content: Text(
                'Search Data Cleared',
                style: TextStyle(color: primaryColor),
              )));
        }
      },
      builder: (context, state) {
        final cubit = appCubit.get(context);
        return WillPopScope(
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
              backgroundColor: secondaryColor,
              elevation: 0,
              titleSpacing: 10,
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.arrow_back_ios_new_outlined,
              //     color: primaryColor,
              //   ),
              //   onPressed: () {
              //     cubit.searchedProducts!.data = [];
              //     goto(
              //       child: homeScreen(),
              //       type: PageTransitionType.fade,
              //       context: context,
              //     );
              //   },
              // ),
              title: Text(
                LocaleKeys.Search.tr(),
                style: TextStyle(color: primaryColor),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    searchController.clear();
                    cubit.clearSearchProducts();
                  },
                  icon: Icon(
                    Icons.clear_all,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      style: TextStyle(color: primaryColor),
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        hintText: 'Type To Search',
                        hintStyle: TextStyle(color: primaryColor),
                        enabled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (String? val) {
                        if (val!.isEmpty || val.trim() == "") {
                          return "";
                        }
                        return null;
                      },
                      onFieldSubmitted: (val) {
                        if (!formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: secondaryColor,
                              duration: Duration(milliseconds: 600),
                              content: Text(
                                'Empty Field',
                                style: TextStyle(color: primaryColor),
                              )));
                          return;
                        } else {
                          cubit.searchProducts(word: val.toString().trim());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  state is getSearchedProductsLoading
                      ? LinearProgressIndicator(
                          backgroundColor: secondaryColor,
                          color: primaryColor,
                          minHeight: 2,
                        )
                      : Container(),
                  state is searchedProductsEmpty
                      ? Text(
                          'There are No Products For this Search',
                          style: TextStyle(color: primaryColor),
                        )
                      : (cubit.searchedProducts == null)
                          ? Text(
                              'Search about Your Products ',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 20,
                              ),
                            )
                          : Expanded(
                              child: ListView(
                              children: cubit.searchedProducts!.data
                                  .map((searchedItem) {
                                return searchedItemBuilder(
                                  imgUrl: searchedItem.image.toString(),
                                  price: searchedItem.price.toString(),
                                  subtitle: searchedItem.descreption.toString(),
                                  title: searchedItem.title.toString(),
                                );
                              }).toList(),
                            )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget searchedItemBuilder({
  required String imgUrl,
  required String title,
  required String subtitle,
  required String price,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: FadeInImage(
            placeholder: AssetImage('assets/images/loading.gif'),
            image: NetworkImage(imgUrl),
          ).image,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
              Text(
                subtitle,
                style: TextStyle(color: primaryColor, fontSize: 14),
              ),
            ],
          ),
        ),
        Text(
          price.toString() + '\$',
          style: TextStyle(color: primaryColor),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}
