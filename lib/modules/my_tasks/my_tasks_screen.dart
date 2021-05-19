import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class MyTasksScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    // return Container();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List tasks = AppCubit.get(context).newTasksList;
        return ListView.builder(
          itemBuilder: (ctx, index) => taskWidget(
            title: tasks[index]['title'],
            onDone: () {
              AppCubit.get(context).updateData(
                  id: tasks[index]['id'], status: 'Done', isDone: 1);
            },
            id: tasks[index]['id'],

            onArchived: () {
              AppCubit.get(context).updateData(
                  id: tasks[index]['id'], status: 'Archived', isDone: 0);
            },
            time: tasks[index]['time'],
            context: context,
            index: index,
          ),
          itemCount: tasks.length,
        );
      },
    );
  }


}
