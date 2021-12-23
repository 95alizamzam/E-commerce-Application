abstract class appCubitStates {}

class appinitalState extends appCubitStates {}

class changeIndexState extends appCubitStates {}

class getCategoriesState extends appCubitStates {}

class getProductssState extends appCubitStates {}

class changeShowMethodState extends appCubitStates {}

class setFavProductFailed extends appCubitStates {}

class setFavProductSuccess extends appCubitStates {
  final String status;
  setFavProductSuccess(this.status);
}

class getFavoritesProductsState extends appCubitStates {}

class getFavoritesProductsLoading extends appCubitStates {}

class getFavoritesProductsError extends appCubitStates {}

class getCatProductsSuccessfully extends appCubitStates {}

class fetchCartProductsSuccessfully extends appCubitStates {}

class fetchCartProductsError extends appCubitStates {}

class addProductTocartSuccessfully extends appCubitStates {
  final String msg;
  addProductTocartSuccessfully(this.msg);
}

class RegisterCartSuccess extends appCubitStates {}

class RegisterCartError extends appCubitStates {}

class changeappColor extends appCubitStates {}

class changeAppMoodState extends appCubitStates {}

class getFilteredProductsLoading extends appCubitStates {}

class getFilteredProductsDone extends appCubitStates {}

class getFilteredProductsFailed extends appCubitStates {}

class FilteredProductsEmpty extends appCubitStates {}

class FiltersCleared extends appCubitStates {}

class getSearchedProductsLoading extends appCubitStates {}

class getSearchedProductsDone extends appCubitStates {}

class searchedProductsEmpty extends appCubitStates {}

class AlreadyHaveCartState extends appCubitStates {}

class clearSearchedProducts extends appCubitStates {}

class getCartDataSuccessfully extends appCubitStates {
  final String cartId;
  getCartDataSuccessfully(this.cartId);
}

class increaseCounterState extends appCubitStates {}

class decreaseCounterState extends appCubitStates {}

class RateNewProductDoneSuccessfully extends appCubitStates {}

class FetchRatingsProductsSuccess extends appCubitStates {}

class changeLanguageSuccessfully extends appCubitStates {}

class RateTheProductSuccessfully extends appCubitStates {}

class ProductsSortedByNames extends appCubitStates {}

class ProductsSortedByPrice extends appCubitStates {}

class ProductsSortedByQuantity extends appCubitStates {}
