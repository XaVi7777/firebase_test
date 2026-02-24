import 'dart:async';

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

  FutureOr<void> _onInit(SplashInitialEvent event, Emitter<SplashState> emit) async{
    final storage = FlutterSecureStorage();
    final idToken = await storage.read(key: 'idToken');
    print(idToken);
    emit(idToken == null ? SplashUnAuthenticatedState (): SplashAuthenticatedState());
  }
}
