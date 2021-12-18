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
            height: 500,
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
                          cubit.changeShowMethod(val: true);
                        },
                        icon: Icon(Icons.grid_view, color: primaryColor),
                        splashRadius: 1,
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.changeShowMethod(val: false);
                        },
                        icon: Icon(Icons.list, color: primaryColor),
                        splashRadius: 1,
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
