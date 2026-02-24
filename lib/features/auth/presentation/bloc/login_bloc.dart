import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/data/models/user_model.dart';
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

      // Firebase Auth — только idToken, без accessToken
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Теперь Firestore видит авторизованного пользователя
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'name': user.displayName ?? '',
                'email': user.email ?? '',
                'lastLogin': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
        } catch (e) {
          print('Firestore error: $e');
        }
      }
    }
  }

  void _handleAuthenticationError(Object error) {
    print('error $error');
  }
}
