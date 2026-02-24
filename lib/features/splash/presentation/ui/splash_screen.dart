import 'package:firebase_test/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (BuildContext context) => SplashBloc()..add(SplashInitialEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          print('splash state $state');
          if (state is SplashAuthenticatedState) {
            context.replace('/home');
          } else if (state is SplashUnAuthenticatedState) {
            context.replace('/login');
          }
        },
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
