import 'package:firebase_test/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      lazy: false,
      child: Scaffold(
        body: Center(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return ElevatedButton(onPressed: () {
                context.read<HomeBloc>().add(HomeLogoutEvent());
              }, child: Text('Log out'));
            }
          ),
        ),
      ),
    );
  }
}
