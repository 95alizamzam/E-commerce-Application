class cartModal {
  String? cartId;
  int? money;

  cartModal.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    money = json['money'];
  }
}
