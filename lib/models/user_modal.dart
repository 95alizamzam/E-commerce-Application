class userModal {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhoneNumber;
  String? userCartId;
  String? userImage;

  userModal.fromJson(Map<String, dynamic> json) {
    userId = json['result']['id'];
    userName = json['result']['userName'];
    userEmail = json['result']['email'];
    userPassword = json['result']['password'];
    userPhoneNumber = json['result']['phoneNumber'];
    userCartId = json['result']['cartCartId'] ?? "empty";
    userImage = json['userImage'];
  }
}
