import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize(
      serverClientId:
          '559358280217-kn1h8a4a87ct92s1ev3sue5obf59igfh.apps.googleusercontent.com',
    );
    signIn.authenticationEvents
        .listen(_handleAuthenticationEvent)
        .onError(_handleAuthenticationError);

    signIn.authenticate();
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final storage = FlutterSecureStorage();

      final idToken = event.user.authentication.idToken;

      storage.write(key: 'idToken', value: idToken);

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final authethicatedUser = userCredential.user;
      if (authethicatedUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authethicatedUser.uid)
            .set({
              'name': authethicatedUser.displayName ?? '',
              'email': authethicatedUser.email,
              'lastLogin': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      }
    }
  }

  void _handleAuthenticationError(Object error) {
    print('error $error');
  }
}
