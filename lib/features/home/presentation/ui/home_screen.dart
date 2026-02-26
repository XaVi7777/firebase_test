import 'package:firebase_test/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(HomeLoadTasksEvent()),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(bottom: 32, top: 16),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeLogoutEvent());
                      },
                      child: Text('Log out'),
                    ),
                    if (state is HomeLoadedState)
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Text(state.tasks[index].text);
                        },
                        itemCount: state.tasks.length,
                      ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _showAddTaskSheet(context);
                      },
                      child: Text('Add task'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter task text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<HomeBloc>().add(HomeAddTaskEvent(text));
                      Navigator.pop(sheetContext);
                    }
                  },
                  child: Text('Add'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
