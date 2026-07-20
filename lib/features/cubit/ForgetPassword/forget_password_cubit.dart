import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Auth_Service/Auth.dart';
import 'forget_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  var email = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void onForgotPasswordPressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    emit(ForgotPasswordLoadingState());

    final message = await Auth.forgotPassword(email.text);

    if (message == "Password reset email sent") {
      emit(ForgotPasswordSuccessState());
    } else {
      emit(ForgotPasswordErrorState(message));
    }
  }

  @override
  Future<void> close() {
    email.dispose();
    return super.close();
  }
}