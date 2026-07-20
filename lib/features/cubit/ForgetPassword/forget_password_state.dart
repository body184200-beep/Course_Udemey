
abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {

}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String error;
  ForgotPasswordErrorState(this.error);
}