import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/app_screens/cat_products.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:page_transition/page_transition.dart';

class categoriesShow extends StatelessWidget {
  const categoriesShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = appCubit.get(context);
        final data = cubit.cat_Modal!.data;
        return Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          width: double.infinity,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => itemBuilder(
              imgurl: data[index].image!,
              title: data[index].title!,
              catId: data[index].id.toString(),
              context: context,
              cubit: cubit,
            ),
            separatorBuilder: (_, index) => const SizedBox(
              width: 10,
            ),
            itemCount: data.length,
          ),
        );
      },
    );
  }
}

Widget itemBuilder({
  required String catId,
  required String imgurl,
  required String title,
  required BuildContext context,
  required appCubit cubit,
}) {
  return InkWell(
    onTap: () {
      cubit.getcatProducts(catId: catId);
      goto(
        child: catProducts(
          fromHome: true,
        ),
        type: PageTransitionType.fade,
        context: context,
      );
    },
    child: Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loading.gif'),
              image: Image(
                image: NetworkImage(imgurl),
              ).image,
              fit: BoxFit.cover,
              height: 100,
              width: 140,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Text(
              title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
