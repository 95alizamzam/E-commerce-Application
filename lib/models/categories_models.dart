class categoriesModal {
  List<categoryModal> data = [];

  categoriesModal.fromJson(List<dynamic> json) {
    json.forEach((element) {
      data.add(categoryModal.fromJson(element));
    });
  }
}

class categoryModal {
  int? id;
  String? title;
  String? descreption;
  String? image;

  categoryModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descreption = json['descreption'];
    image = json['image'];
  }
}
