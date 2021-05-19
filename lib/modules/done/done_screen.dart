import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    // return Container();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List tasks = AppCubit.get(context).doneTasksList;
        return ListView.builder(
          itemBuilder: (ctx, index) => taskWidget(
            title: tasks[index]['title'],
            onDone: () {
              AppCubit.get(context)
                  .updateData(id: tasks[index]['id'], status: 'New', isDone: 0);
            },
            onArchived: () {
              AppCubit.get(context).updateData(
                  id: tasks[index]['id'], status: 'Archived', isDone: 1);
            },
            time: tasks[index]['time'],
            isDone: true,
            id: tasks[index]['id'],
            context: context,
            index: index,
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
