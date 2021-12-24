import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/cat_products.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:page_transition/page_transition.dart';

class categoryItemBuilder extends StatelessWidget {
  const categoryItemBuilder(
      {Key? key,
      required this.catId,
      required this.imageUrl,
      required this.subtitle,
      required this.title})
      : super(key: key);

  final String catId;
  final String imageUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = appCubit.get(context);
          return Card(
            elevation: 10,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor),
            ),
            margin: const EdgeInsets.all(0),
            shadowColor: primaryColor,
            child: GestureDetector(
              onTap: () {
                cubit.getcatProducts(catId: catId);
                goto(
                  child: catProducts(),
                  type: PageTransitionType.fade,
                  context: context,
                );
              },
              child: Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/loading.gif'),
                        image: Image(
                          image: NetworkImage(imageUrl),
                        ).image,
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        title + ' Category',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
