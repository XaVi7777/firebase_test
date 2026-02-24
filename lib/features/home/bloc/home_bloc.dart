import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()){
    on<HomeLogoutEvent>(_onLogout);
  }

  FutureOr<void> _onLogout(HomeLogoutEvent event, Emitter<HomeState> emit)async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'idToken');
      }
}
