import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    // return Container();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List tasks = AppCubit.get(context).archivedTasksList;
        return ListView.builder(
          itemBuilder: (ctx, index) => taskWidget(
            title: tasks[index]['title'],
            onDone: () {
              // AppCubit.get(context)
              //     .updateData(id: tasks[index]['id'], status: 'New');
            },
            isArchived: true,
            onArchived: () {
              if (AppCubit.get(context).archivedTasksList[index]['isDone'] ==
                  0) {
                AppCubit.get(context).updateData(
                    id: tasks[index]['id'], status: 'New', isDone: 0);
              } else {
                AppCubit.get(context).updateData(
                    id: tasks[index]['id'], status: 'Done', isDone: 1);
              }
            },
            time: tasks[index]['time'],
            isDone: tasks[index]['isDone'] == 1 ? true : false,
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
