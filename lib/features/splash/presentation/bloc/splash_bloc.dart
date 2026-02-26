import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashAuthenticatedState extends SplashState {}

class SplashUnAuthenticatedState extends SplashState {}

abstract class SplashEvent {}

class SplashInitialEvent extends SplashEvent {}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onInit);
  }

  FutureOr<void> _onInit(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      final storage = FlutterSecureStorage();
      final idToken = await storage.read(key: 'idToken');
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print('userCredential ${userCredential.user?.email}');
      emit(
        idToken == null
            ? SplashUnAuthenticatedState()
            : SplashAuthenticatedState(),
      );
    } catch (e) {
      print('e $e');
    }
  }
}
