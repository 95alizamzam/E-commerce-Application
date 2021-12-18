import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_node/models/cart_model.dart';
import 'package:flutter_node/models/categories_models.dart';
import 'package:flutter_node/models/products_models.dart';
import 'package:flutter_node/models/ratingModal.dart';
import 'package:flutter_node/shared/app_cubit/cubit_states.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/shared_prefrences/shared_prefrences.dart';
import 'package:flutter_node/shared/styles.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class appCubit extends Cubit<appCubitStates> {
  appCubit() : super(appinitalState());

  static appCubit get(context) => BlocProvider.of(context);

  List<String> appTitiles = [
    "home Screen",
    "Categories",
    "Favorites",
    "Shpping cart",
    "Settings",
  ];

  List<Widget> appbanners = const [
    Image(image: AssetImage('assets/banners/banner1.jpg')),
    Image(image: AssetImage('assets/banners/banner2.jpg')),
    Image(image: AssetImage('assets/banners/banner3.jpg')),
    Image(image: AssetImage('assets/banners/banner4.jpg')),
  ];

  // fetch all categories
  categoriesModal? cat_Modal;
  void getAllCategories() {
    http.get(Uri.parse(basicUrl + '/category')).then((value) {
      cat_Modal = categoriesModal.fromJson(json.decode(value.body));
      emit(getCategoriesState());
    }).catchError((error) {
      print(error);
    });
  }

  //fetch all products
  productsModal? product_Modal;
  void getAllProducts() {
    http.get(Uri.parse(basicUrl + '/product')).then((value) {
      product_Modal = productsModal.fromJson(json.decode(value.body));
      emit(getProductssState());
    }).catchError((error) {
      print(error);
    });
  }

  //fetch product to certain category
  productsModal? catProducts;
  void getcatProducts({
    required String catId,
  }) {
    http.post(Uri.parse(basicUrl + '/product'),
        body: {"token": userToken, "catId": catId}).then((value) {
      catProducts = productsModal.fromJson(json.decode(value.body));
      emit(getCatProductsSuccessfully());
    }).catchError((error) {
      print(error);
    });
  }

  // witch between grid and list view
  bool isGrid = false;
  void changeShowMethod({required bool val}) {
    isGrid = val;
    emit(changeShowMethodState());
  }

  // add/remove  product to favorite list
  final List<int> productFavState = [];
  void setFavProduct({
    required int productId,
    required String userId,
  }) {
    http.post(Uri.parse(basicUrl + '/product/addfavorite'), body: {
      "userId": userId,
      "productId": productId.toString(),
      "token": userToken,
    }).then((value) {
      final returnedData = json.decode(value.body);
      if (returnedData['Error'] != null) {
        emit(setFavProductFailed());
      } else {
        if (returnedData['status'] == 'Deleted from favorites') {
          getFavoritesProducts(userId: userId).then((_) {
            productFavState.remove(productId);
          });
          emit(setFavProductSuccess('deleted'));
        } else {
          getFavoritesProducts(userId: userId).then((_) {
            productFavState.add(productId);
          });
          emit(setFavProductSuccess('added'));
        }
      }
      ;
    }).catchError((error) {
      print(error);
    });
  }

  // fetch all favorites products
  productsModal? favProducts;
  Future<void> getFavoritesProducts({
    required String userId,
  }) async {
    http.post(Uri.parse(basicUrl + '/product/favorite'), body: {
      "token": userToken,
      "userId": userId,
    }).then((value) {
      emit(getFavoritesProductsLoading());
      final data = json.decode(value.body);
      favProducts = productsModal.fromJson(data);
      emit(getFavoritesProductsState());
    }).catchError((error) {
      emit(getFavoritesProductsError());
      print(error);
    });
  }

  // register Cart
  cartModal? cartObject;
  void registerCart({
    required String userId,
  }) {
    http.post(Uri.parse(basicUrl + '/cart/register'),
        body: {"userId": userId}).then((value) {
      if (value.statusCode == 409) {
        emit(AlreadyHaveCartState());
      } else {
        cartObject = cartModal.fromJson(json.decode(value.body));
        emit(RegisterCartSuccess());
      }
    }).catchError((error) {
      emit(RegisterCartError());
      print(error);
    });
  }

  // it used only where cartId in userdata != empty
  void getCartData({
    required String cartId,
  }) {
    http.post(Uri.parse(basicUrl + '/cart/cartData'), body: {
      "cartId": cartId,
    }).then((value) {
      cartObject = cartModal.fromJson(json.decode(value.body)['result']);
      emit(getCartDataSuccessfully(cartId));
    }).catchError((error) {
      print('Error' + error.toString());
    });
  }

// add/remove  product to cart
  final List<int> productsInCart = [];
  void addItemsToCart({
    required int pId,
    required String cartId,
  }) {
    http.post(Uri.parse(basicUrl + '/cart/addproducts'), body: {
      "productId": pId.toString(),
      "cartId": cartId,
      "token": userToken
    }).then((value) {
      if (value.statusCode == 402) {
        print(value.statusCode);
        print("Expired Token");
      } else if (value.statusCode == 200) {
        final data = json.decode(value.body);
        if (data['status'] == 'Deleted from cart') {
          emit(addProductTocartSuccessfully('deleted'));
          productsInCart.remove(pId);
          fetchAllCartProducts(cartId: cartId);
        } else if (data['status'] == 'added to cart') {
          emit(addProductTocartSuccessfully('added'));
          productsInCart.add(pId);
          fetchAllCartProducts(cartId: cartId);
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  // fetch all products in cart
  productsModal? cartProducts;
  void fetchAllCartProducts({
    required String cartId,
  }) {
    http.post(
      Uri.parse(basicUrl + '/cart/products'),
      body: {
        "cartId": cartId,
        "token": userToken,
      },
    ).then((value) {
      cartProducts = productsModal.fromJson(json.decode(value.body));
      calculateTotal();
      emit(fetchCartProductsSuccessfully());
    }).catchError((error) {
      print(error);
      emit(fetchCartProductsError());
    });
  }

  int totalPrice = 0;
  void calculateTotal() {
    totalPrice = 0;
    cartProducts!.data.forEach((element) {
      totalPrice += element.price!;
    });
  }

  // helper funcrions

  //1- change primary and secondary colors
  void changeAppColors({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: const Text('Pick a color!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(child: Text('Change Primary Color')),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text('change app Primary Color'),
                                      content: SingleChildScrollView(
                                        child: MaterialPicker(
                                          enableLabel: true,
                                          pickerColor: primaryColor,
                                          onColorChanged: (Color clr) {
                                            primaryColor = clr;
                                            sharedPrefrences().setIntData(
                                                key: 'primaryColor',
                                                value: primaryColor.value);

                                            emit(changeappColor());
                                          },
                                        ),
                                      ),
                                    ));
                          },
                          icon: Icon(
                            Icons.color_lens,
                            color: primaryColor,
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(child: Text('Change Secondary Color')),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text('change app secondary Color'),
                                      content: SingleChildScrollView(
                                        child: MaterialPicker(
                                          enableLabel: true,
                                          pickerColor: secondaryColor,
                                          onColorChanged: (Color clr) {
                                            secondaryColor = clr;
                                            sharedPrefrences().setIntData(
                                                key: 'secondaryColor',
                                                value: secondaryColor.value);
                                            emit(changeappColor());
                                          },
                                        ),
                                      ),
                                    ));
                          },
                          icon: Icon(
                            Icons.color_lens,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }

  //2- change app mood

  void changeAppMood({required BuildContext context, required bool val}) {
    isDark = val;

    if (isDark == false) {
      primaryColor = Colors.blue;
      secondaryColor = Colors.white;
    } else {
      primaryColor = HexColor('#ffd700');
      secondaryColor = HexColor('#13121a');
    }

    sharedPrefrences().setBoolData(key: 'isDark', value: isDark);

    sharedPrefrences()
        .setIntData(key: 'primaryColor', value: primaryColor.value);
    sharedPrefrences()
        .setIntData(key: 'secondaryColor', value: secondaryColor.value);

    emit(changeAppMoodState());
  }

  double maxPriceValue = 0;
  double minPriceValue = 0;
  List<String> categories = [];
  void getFilteredProducts({
    required List<String> selectedCategories,
    required double selectedPrice,
    required double minPriceValue,
  }) {
    emit(getFilteredProductsLoading());
    http.post(Uri.parse(basicUrl + '/product/filter'), body: {
      'maxPrice': selectedPrice.toString(),
      'minPrice': minPriceValue.toString(),
      "selectedCategories": selectedCategories.toString(),
    }).then((value) {
      final filteredData = json.decode(value.body)['result'];
      if (filteredData.toString() == "[]") {
        emit(FilteredProductsEmpty());
      } else if (value.statusCode == 200) {
        product_Modal = productsModal.fromJson(filteredData);
        emit(getFilteredProductsDone());
      } else {
        emit(getFilteredProductsFailed());
      }
    }).catchError((error) {
      print(error);
      emit(getFilteredProductsFailed());
    });
  }

  void resetFilters() {
    maxPriceValue = 0;
    minPriceValue = 0;
    categories = [];

    getAllProducts();
    emit(FiltersCleared());
  }

  productsModal? searchedProducts;
  void searchProducts({required String word}) {
    http.post(Uri.parse(basicUrl + '/product/search'), body: {
      "searchWord": word,
    }).then((value) {
      emit(getSearchedProductsLoading());
      final data = json.decode(value.body);

      if (data['result'].toString() == "[]") {
        emit(searchedProductsEmpty());
      } else {
        searchedProducts = productsModal.fromJson(data['result']);
        emit(getSearchedProductsDone());
      }
    }).catchError((error) {
      print('Error');
    });
  }

  void clearSearchProducts() {
    searchedProducts!.data = [];
    emit(clearSearchedProducts());
  }

  void rateProducts({
    required String userId,
    required int productId,
    required double rateValue,
  }) {
    http.post(Uri.parse(basicUrl + '/product/rating'), body: {
      "userId": userId,
      "productId": productId.toString(),
      "ratingValue": rateValue.toString(),
    }).then((value) {
      if (value.statusCode == 200) {
        fetchUserRatings(userId: userId);
      } else {
        print('Error in rateProducts Method');
      }
    }).catchError((error) {
      print('Error  = $error');
    });
  }

  RatingsModal? ratedProducts;
  void fetchUserRatings({
    required String userId,
  }) {
    http.post(Uri.parse(basicUrl + '/product/fetchrating'), body: {
      "userId": userId,
    }).then((value) {
      final data = json.decode(value.body)['result'];
      ratedProducts = RatingsModal.fromJson(data);
      emit(FetchRatingsProductsSuccess());
    }).catchError((error) {
      print('Error = $error');
    });
  }

  void removeProductRate({
    required String userId,
    required int productId,
  }) {
    http.post(Uri.parse(basicUrl + '/product/removeRate'), body: {
      "userId": userId,
      "productId": productId.toString(),
    }).then((value) {
      if (value.statusCode == 200) {
        fetchUserRatings(userId: userId);
      }
    }).catchError((err) {
      print('Error : $err ');
    });
  }

  // last thing.....
  List<Map<String, int>> orderDetails = [];

  void increaseCounter({required int productId}) {
    orderDetails.forEach((element) {
      if (element['ProductId'] == productId) {}
    });
    emit(increaseCounterState());
  }

  void decreaseCounter() {
    emit(decreaseCounterState());
  }

  double calPrice({
    required double price,
    required int quantity,
  }) {
    return price * quantity;
  }

  void changeAppLanguage({
    required BuildContext context,
    required Locale val,
  }) {
    context.setLocale(val).then((value) {
      emit(changeLanguageSuccessfully());
    }).catchError((err) {
      print('Error with Translation Process');
    });
  }
}
