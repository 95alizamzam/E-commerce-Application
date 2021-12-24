class avgRate {
  List<rate> data = [];
  avgRate.fromJson(List<dynamic> json) {
    json.forEach((element) {
      data.add(rate.fromJson(element));
    });
  }
}

class rate {
  double? ratingValue;
  int? productId;
  double? productAvgRate;

  rate.fromJson(Map<String, dynamic> json) {
    ratingValue = double.parse(json['ratingValue'].toString());
    productId = json['productId'];
    productAvgRate = double.parse(json['avgRate'].toString());
  }
}
