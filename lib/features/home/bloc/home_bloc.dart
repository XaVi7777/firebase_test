import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/data/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}

class HomeLoadTasksEvent extends HomeEvent {}

class HomeAddTaskEvent extends HomeEvent {
  final String text;
  HomeAddTaskEvent(this.text);
}

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<TaskModel> tasks;

  HomeLoadedState({required this.tasks});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeLogoutEvent>(_onLogout);
    on<HomeLoadTasksEvent>(_onHomeLoadTasks);
    on<HomeAddTaskEvent>(_onAddTask);
  }

  FutureOr<void> _onLogout(
    HomeLogoutEvent event,
    Emitter<HomeState> emit,
  ) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }

  FutureOr<void> _onHomeLoadTasks(
    HomeLoadTasksEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .get();
      final List<TaskModel> tasks = response.docs.map((json) {
        final model = TaskModel.fromJson(json.data());
        return model;
      }).toList();
      emit(HomeLoadedState(tasks: tasks));
    } catch (e) {
      print('load error $e');
    }
  }

  FutureOr<void> _onAddTask(
    HomeAddTaskEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final task = TaskModel(text: event.text);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add(task.toJson());
      add(HomeLoadTasksEvent());
    } catch (e) {
      print('add task error $e');
    }
  }
}
