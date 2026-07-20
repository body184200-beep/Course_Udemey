import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Auth_Service/Auth.dart';
import 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  var email = TextEditingController();
  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void onSignInPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(SignInLoadingState());

    final message = await Auth.signInWithEmail(
      email.text,
      password.text,
    );

    if (message == "Signed in successfully") {
      emit(SignInSuccessState());
    } else {
      emit(SignInErrorState(message));
    }
  }

  @override
  Future<void> close() {
    email.dispose();
    password.dispose();
    return super.close();
  }
}