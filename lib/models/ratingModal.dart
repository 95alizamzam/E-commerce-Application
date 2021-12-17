class RatingsModal {
  List<RatingModal> data = [];

  RatingsModal.fromJson(List<dynamic> json) {
    json.forEach((element) {
      data.add(RatingModal.fromJson(element));
    });
  }
}

class RatingModal {
  String? userId;
  int? productId;
  double? ratingValue;

  RatingModal.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    productId = json['productId'];
    ratingValue = double.parse(json['ratingValue'].toString());
  }
}
