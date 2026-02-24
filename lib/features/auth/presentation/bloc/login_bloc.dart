import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

abstract class LoginEvent {}

class LoginAuthWithGoogleEvent extends LoginEvent {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginAuthWithGoogleEvent>(_onLoginWithGoogle);
  }

  FutureOr<void> _onLoginWithGoogle(
    LoginAuthWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId:
            '257182906865-34kq141bu0hl206vfip67o3pequgr618.apps.googleusercontent.com',
      );

      signIn.authenticationEvents.listen((event) {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            print('Signed in: ${event.user.authentication.idToken}');
            final storage = FlutterSecureStorage();
            storage.write(
              key: 'idToken',
              value: event.user.authentication.idToken,
            );

          case GoogleSignInAuthenticationEventSignOut():
            print('Signed out');
        }
      });

      // Запуск аутентификации
      await signIn.authenticate();
    } catch (e) {
      print('Google sign-in error: $e');
    }
  }
}
