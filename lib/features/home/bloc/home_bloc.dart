import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/data/models/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class HomeEvent {}

class HomeLogoutEvent extends HomeEvent {}

class HomeLoadTasksEvent extends HomeEvent {}

class HomeAddTaskEvent extends HomeEvent {
  final String text;
  HomeAddTaskEvent(this.text);
}

abstract class HomeState {}

class HomeInitialState extends HomeState {}

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
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'idToken');
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
        
      final tasks = response.docs.map((current) {
        return TaskModel.fromJson(current.data());
      }).toList();
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add({'text': event.text, 'createdAt': FieldValue.serverTimestamp()});
      add(HomeLoadTasksEvent());
    } catch (e) {
      print('add task error $e');
    }
  }
}
