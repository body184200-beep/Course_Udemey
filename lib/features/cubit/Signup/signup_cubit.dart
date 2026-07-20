import 'package:fire_base/features/cubit/Signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Auth_Service/Auth.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  var email = TextEditingController();
  var password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void onSignUpPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(SignUpLoadingState());

    final message = await Auth.signUpWithEmail(
      email.text,
      password.text,
    );

    if (message == "Signed up successfully") {
      emit(SignUpSuccessState());
    } else {
      emit(SignUpErrorState(message));
    }
  }

  @override
  Future<void> close() {
    email.dispose();
    password.dispose();
    return super.close();
  }
}