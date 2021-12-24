import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/home_screen/grid_shape.dart';
import 'package:flutter_node/Widgets/home_screen/list_shape.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';

class productsWidget extends StatelessWidget {
  const productsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          return Container(
            height: 400,
            child: Column(
              children: [
                Container(
                  color: secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        LocaleKeys.Products.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          cubit.changeShowMethod(
                            val: cubit.isGrid ? false : true,
                          );
                        },
                        icon: Icon(
                          cubit.isGrid ? Icons.list : Icons.grid_view,
                          color: primaryColor,
                        ),
                        splashRadius: 1,
                      ),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: primaryColor,
                        ),
                        color: secondaryColor,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        itemBuilder: (_) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                cubit.sortProductsAlpatically();
                              },
                              child: Text(
                                'Sort Alphabetically',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                cubit.sortProductsPrice();
                              },
                              child: Text(
                                'Sort by price',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                cubit.sortProductsQuantity();
                              },
                              child: Text(
                                'Sort by Quantity',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  child: cubit.isGrid ? gridShape() : listShape(),
                )),
              ],
            ),
          );
        });
  }
}
