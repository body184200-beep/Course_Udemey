abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {

}

class SignUpErrorState extends SignUpState {
  final String error;
  SignUpErrorState(this.error);
}