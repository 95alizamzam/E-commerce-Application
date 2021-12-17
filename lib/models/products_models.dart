class productsModal {
  List<productModal> data = [];

  productsModal.fromJson(List<dynamic> json) {
    json.forEach((element) {
      data.add(productModal.fromJson(element));
    });
  }
}

class productModal {
  int? id;
  String? title;
  String? descreption;
  String? image;
  int? catId;
  int? price;
  int? quantity;

  productModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descreption = json['descreption'];
    image = json['image'];
    catId = json['categoryId'];
    price = json['price'];
    quantity = json['quantity'];
  }
}
