abstract class userCubitStates {}

class userinitialState extends userCubitStates {}

class tokenExpiredState extends userCubitStates {}

class hiddenSplachScreen extends userCubitStates {}

class changeThemeState extends userCubitStates {}

class takeImageState extends userCubitStates {}

class changeSecureState extends userCubitStates {}

class RegisterDoneState extends userCubitStates {}

class RegisterLoadingState extends userCubitStates {}

class RegisterErrorState extends userCubitStates {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}

class loginStateLoading extends userCubitStates {}

class loginStateDone extends userCubitStates {}

class getUserDataSuccessfully extends userCubitStates {}

class getUserDataFailed extends userCubitStates {}

class autoLogoutState extends userCubitStates {}

class loginStateFailed extends userCubitStates {
  final errorMsg;
  loginStateFailed(this.errorMsg);
}

class checkInternetWithSuccess extends userCubitStates {}

class checkInternetWithError extends userCubitStates {}

class checkInternetSuccsessfully extends userCubitStates {
  final bool internetState;
  checkInternetSuccsessfully(this.internetState);
}

class updateUserDataLoading extends userCubitStates {}

class updateUserDataDone extends userCubitStates {}

class takeCartState extends userCubitStates {}
