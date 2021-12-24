import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/Widgets/product_details/product_info.dart';
import 'package:flutter_node/Widgets/product_details/rating_widget.dart';
import 'package:flutter_node/app_screens/home_screen.dart';
import 'package:flutter_node/shared/app_cubit/cubit.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:flutter_node/shared/user_cubit/cubit.dart';
import 'package:page_transition/page_transition.dart';

class productDetails extends StatelessWidget {
  const productDetails({
    Key? key,
    required this.productId,
    required this.fromHome,
  }) : super(key: key);

  final productId;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        if (state is setFavProductSuccess) {
          showSnackBar(
            context: context,
            color: secondaryColor,
            message: state.status == 'added'
                ? "added to your Favorites"
                : "Deleted From your Favorites",
            messageColor: primaryColor,
          );
        }
        if (state is addProductTocartSuccessfully) {
          showSnackBar(
            context: context,
            color: secondaryColor,
            message: state.msg == 'added'
                ? 'added to your Cart'
                : 'Deleted From your Cart',
            messageColor: primaryColor,
          );
        }
        if (state is RateTheProductSuccessfully) {
          showSnackBar(
            context: context,
            color: secondaryColor,
            message: 'Rating Done Successfully',
            messageColor: primaryColor,
          );
        }
      },
      builder: (context, state) {
        final userData = userCubit.get(context).userObject;
        final cubit = appCubit.get(context);
        final data = cubit.product_Modal!.data;
        final product = data.firstWhere((element) => element.id == productId);

        return WillPopScope(
          onWillPop: () async {
            goto(
              child: homeScreen(),
              type: PageTransitionType.fade,
              context: context,
            );
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: secondaryColor,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    collapsedHeight: 20,
                    toolbarHeight: 20,
                    expandedHeight: 400,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image(
                        image: NetworkImage(product.image!),
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 20),
                        productInfo(
                          title: product.title!,
                          descreption: product.descreption!,
                          price: product.price.toString(),
                          quantity: product.quantity.toString(),
                        ),
                        const SizedBox(height: 40),
                        ProductDetailsButton(
                          index: 2,
                          text: 'Rating the Product',
                          clr: secondaryColor,
                          productId: productId,
                          userId: userData!.userId.toString(),
                          cubit: cubit,
                          cartId: null,
                        ),
                        const SizedBox(height: 20),
                        cubit.cartObject == null
                            ? Container()
                            : ProductDetailsButton(
                                index: 0,
                                text: 'Add To Cart',
                                clr: secondaryColor,
                                productId: productId,
                                userId: userData.userId.toString(),
                                cubit: cubit,
                                cartId: cubit.cartObject!.cartId.toString(),
                              ),
                        const SizedBox(height: 20),
                        ProductDetailsButton(
                          index: 1,
                          text: 'Add To Favorites',
                          clr: secondaryColor,
                          productId: productId,
                          userId: userData.userId.toString(),
                          cubit: cubit,
                          cartId: null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
