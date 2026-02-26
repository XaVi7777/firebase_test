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
    // Firebase сам хранит сессию, просто проверяем текущего пользователя
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emit(SplashAuthenticatedState());
    } else {
      emit(SplashUnAuthenticatedState());
    }
  }
}
