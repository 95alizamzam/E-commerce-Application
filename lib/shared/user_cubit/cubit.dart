import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_node/models/user_modal.dart';
import 'package:flutter_node/shared/constants.dart';
import 'package:flutter_node/shared/shared_prefrences/shared_prefrences.dart';
import 'package:flutter_node/shared/user_cubit/cubit_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class userCubit extends Cubit<userCubitStates> {
  userCubit() : super(userinitialState());

  static userCubit get(context) => BlocProvider.of(context);

  void disappearSplachScreen() {
    Future.delayed(Duration(seconds: 6), () => {emit(hiddenSplachScreen())});
  }

  // check internet connection state
  final Connectivity _connectivity = Connectivity();
  bool? connect_to_internet;
  void check_internet() {
    _connectivity.checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        connect_to_internet = false;
        emit(checkInternetWithSuccess());
      } else {
        connect_to_internet = true;
        emit(checkInternetWithSuccess());
      }
    }).catchError((error) {
      emit(checkInternetWithError());
    });
  }

  void monitiringConnection() {
    check_internet();
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        connect_to_internet = false;
        emit(checkInternetSuccsessfully(connect_to_internet!));
      } else {
        connect_to_internet = true;
        emit(checkInternetSuccsessfully(connect_to_internet!));
      }
    });
  }

  // pick user image
  XFile? pickedImage;
  File? image;
  void pickUserImage({
    required ImageSource src,
  }) async {
    final ImagePicker _picker = ImagePicker();
    if (src == ImageSource.camera) {
      pickedImage = await _picker.pickImage(source: ImageSource.camera);
      image = new File(pickedImage!.path);
      emit(takeImageState());
    } else {
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      image = new File(pickedImage!.path);
      emit(takeImageState());
    }
  }

  // change secure for password
  bool isSecure = false;
  void changeSecure() {
    isSecure = !isSecure;
    emit(changeSecureState());
  }

  // register new user Account
  void registerUser({
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required File userImage,
  }) async {
    emit(RegisterLoadingState());
    // create the post request which hold text data and image file
    final request =
        http.MultipartRequest('POST', Uri.parse(basicUrl + '/user/signup'));

    // text fields
    request.fields['email'] = email;
    request.fields['userName'] = userName;
    request.fields['password'] = password;
    request.fields['phoneNumber'] = phoneNumber;

    final imageEtension = userImage.path.split('/').last.split('.').last;
    // image File
    final sendingImageFile = await http.MultipartFile.fromPath(
      'userImage',
      userImage.path,
      filename: userImage.path.split('/').last,
      // so important field
      contentType: MediaType('image', imageEtension),
    );
    //final request with all text fields and image
    request.files.add(sendingImageFile);

    Map<String, dynamic> data = {};
    try {
      final response = await request.send();
      if (response.statusCode == 409) {
        emit(RegisterErrorState('Email is Already Exist'));
      } else {
        //convert incomming response bode to json format
        response.stream.transform(utf8.decoder).listen((event) {
          data.addAll(json.decode(event));
        }).onDone(() async {
          // doing the following after get the all body data
          userToken = data['token'];
          tokenDate = int.parse(data['expiryDate']);
          sharedPrefrences()
              .setStringData(key: 'storedToken', value: userToken);
          sharedPrefrences().setIntData(key: 'tokenDate', value: tokenDate);

          getUserData();
          emit(RegisterDoneState());
        });
      }
    } catch (error) {
      print(error.toString());
      emit(RegisterErrorState('Opps, some Error occupied !'));
    }
  }

  // login with an existing account
  void login({
    required String email,
    required String password,
  }) {
    emit(loginStateLoading());
    http.post(Uri.parse(basicUrl + '/user/signin'), body: {
      "email": email,
      "password": password,
    }).then((value) async {
      if (value.statusCode == 409) {
        final errorMsg = json.decode(value.body)['Error'];
        emit(loginStateFailed(errorMsg));
      } else {
        userToken = json.decode(value.body)['token'];
        tokenDate = int.parse(json.decode(value.body)['expiryDate']);

        sharedPrefrences().setStringData(key: 'storedToken', value: userToken);
        sharedPrefrences().setIntData(key: 'tokenDate', value: tokenDate);

        getUserData();
        emit(loginStateDone());
      }
    }).catchError((error) {
      print(error);
    });
  }

  // get user data
  userModal? userObject;
  void getUserData() {
    http.post(Uri.parse(basicUrl + '/user'), body: {"token": userToken}).then(
        (value) {
      if (value.statusCode == 409) {
        emit(getUserDataFailed());
      } else {
        userObject = userModal.fromJson(json.decode(value.body));
        emit(getUserDataSuccessfully());
      }
    }).catchError((error) {
      print(error);
    });
  }

  // check expiration of token
  // void checkValidToken() {
  //   Future.delayed(Duration(hours: tokenDate), () => {autoLogout()});
  // }

  void updateUserData({
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String userId,
    File? userImage,
  }) async {
    emit(updateUserDataLoading());
    final request =
        http.MultipartRequest('PATCH', Uri.parse(basicUrl + '/user/update'));

    // text fields
    request.fields['email'] = email;
    request.fields['userName'] = userName;
    request.fields['password'] = password;
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['userId'] = userId;

    if (userImage != null) {
      final imageEtension = userImage.path.split('/').last.split('.').last;
      // image File
      final sendingImageFile = await http.MultipartFile.fromPath(
        'userImage',
        userImage.path,
        filename: userImage.path.split('/').last,
        // so important field
        contentType: MediaType('image', imageEtension),
      );
      //final request with all text fields and image
      request.files.add(sendingImageFile);
    }
    final res = await request.send();

    if (res.statusCode == 200) {
      emit(updateUserDataDone());
    } else {
      print(res.statusCode);
      print('Error');
    }
  }

  // auto logout when token is expired
  // void autoLogout() async {
  //   userToken = "";
  //   tokenDate = 0;
  //   sharedPrefrences.deleteFields(Key: 'tokenDate').then((value) {
  //     sharedPrefrences.deleteFields(Key: 'storedToken').then((value) {
  //       emit(autoLogoutState());
  //     });
  //   });
  // }
}
