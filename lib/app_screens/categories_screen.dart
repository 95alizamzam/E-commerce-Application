import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/cat_products.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/translations/local_keys.dart';
import 'package:page_transition/page_transition.dart';

class categoriesScreen extends StatelessWidget {
  const categoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        final data = cubit.cat_Modal!.data;
        return SafeArea(
          top: true,
          bottom: true,
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
                titleSpacing: 10,
                title: Text(LocaleKeys.Categories.tr(),
                    style: TextStyle(color: primaryColor)),
                backgroundColor: secondaryColor,
              ),
              body: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                itemBuilder: (_, index) => catItemBuilder(
                  catId: data[index].id.toString(),
                  imageUrl: data[index].image!,
                  title: data[index].title!,
                  subtitle: data[index].descreption!,
                  context: context,
                  cubit: cubit,
                ),
                separatorBuilder: (_, index) => Divider(
                  color: primaryColor,
                  endIndent: 10,
                  indent: 10,
                ),
                itemCount: data.length,
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget catItemBuilder({
  required String catId,
  required String imageUrl,
  required String title,
  required String subtitle,
  required BuildContext context,
  required appCubit cubit,
}) {
  return Container(
    height: 70,
    padding: const EdgeInsets.all(4),
    child: Row(
      children: [
        FadeInImage(
          placeholder: AssetImage('assets/images/loading.gif'),
          image: Image(
            image: NetworkImage(imageUrl),
          ).image,
          width: 80,
          height: 100,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title + 'Category',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            cubit.getcatProducts(catId: catId);
            goto(
              child: catProducts(),
              type: PageTransitionType.fade,
              context: context,
            );
          },
          icon: Icon(
            Icons.arrow_forward_ios,
            color: primaryColor,
          ),
        )
      ],
    ),
  );
}
